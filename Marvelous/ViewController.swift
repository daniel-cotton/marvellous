//
//  ViewController.swift
//  Marvelous
//
//  Created by dcotton on 13/06/2018.
//  Copyright © 2018 dcotton. All rights reserved.
//

import UIKit
import SwiftyJSON
import WatchConnectivity
import Apollo;

class ViewController: UIViewController, WCSessionDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var projectIdField: UITextField!;
    @IBOutlet weak var headerView: UIView!;
    @IBOutlet weak var collectionView: UICollectionView!;
    
    var current : Int = 1;
    
    private var imageMap: [String: UIImage] = [:];
    private var apollo: ApolloClient? = nil;
    private var projects: Set<Project> = Set<Project>();
    private var sortedProjects: [Project] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if WCSession.isSupported() {
            WCSession.default.delegate = self as! WCSessionDelegate
            WCSession.default.activate()
        }
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOpacity = 0.3
        headerView.layer.shadowOffset = CGSize.zero
        headerView.layer.shadowRadius = 1
        headerView.layer.shadowPath = UIBezierPath(rect: headerView.bounds).cgPath;
        let token = getPreference(key: "access_token");
        if (token == nil) {
            storePreference(key: "access_token", value: "");
            self.performSegue(withIdentifier: "logoutSegue", sender: self)
            return;
        }
        apollo = {
            let configuration = URLSessionConfiguration.default
            // Add additional headers as needed
            configuration.httpAdditionalHeaders = ["Authorization": "Bearer " + token!] // Replace `<token>`
            
            let url = URL(string: "https://marvelapp.com/graphql")!
            
            return ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
        }();
        apollo?.fetch(query: MainQueryQuery()) { (result, error) in
            if (error != nil) {
                self.storePreference(key: "access_token", value: "");
                self.performSegue(withIdentifier: "logoutSegue", sender: self)
                return;
            }
            let data = result?.data;
            let projectArray = data?.user?.projects?.edges;
            for (project) in (projectArray)! {
                let projectName : String = (project?.node?.name)!;
                let prototypeUrl : String = (project?.node?.prototypeUrl)!;
                let projectPreviewURL : String = (project?.node?.screens?.edges[0]?.node?.content?.url)!;
                let createdDate: String = (project?.node!.createdAt)!;
                print(projectName, projectPreviewURL);
                self.projects.insert(Project(project: projectName, imgUrl: projectPreviewURL, prototypeUrl: prototypeUrl, createdDate: createdDate));
            }
            self.sortedProjects = self.projects.sorted(by: { $0.createdDate > $1.createdDate });
            print(self.sortedProjects)
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.projects.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCard;
        let project = self.sortedProjects[indexPath.row];
        cell.displayContent(project: project);
        cell.cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        return cell;
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        print("Tap:", location, indexPath);
        if let index = indexPath {
            let project = self.sortedProjects[index.row];
            let refreshAlert = UIAlertController(title: "Sync?", message: "Do you want to sync " + project.projectName + " to your watch?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.startLoadingOnWatch();
                self.fetchProjectDetails(projectID: project.prototypeId);
                self.fetchProjectHotspots(projectID: project.prototypeId);
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Cancel clicked.")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func isStringEmpty(stringValue:String) -> Bool
    {
        var returnValue = false
        
        if stringValue.isEmpty  == true
        {
            returnValue = true
            return returnValue
        }
        
        // Make sure user did not submit number of empty spaces
        
        return returnValue
        
    }
    
    func storePreference(key: String, value: String) {
        let defaults = UserDefaults(suiteName: "group.uk.co.daniel-cotton.marvelous")
        defaults?.set(value, forKey: key);
    }
    
    func getPreference(key: String) -> String? {
        let defaults = UserDefaults(suiteName: "group.uk.co.daniel-cotton.marvelous")
        return defaults!.string(forKey: key);
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        print("Recieved msg from watch");
        self.current = self.current + 1;
        
        replyHandler(messageData)
    }
    
    func pingImageToWatch(imgUrl: String, title : String, count : Int, id : String, width : Int, height : Int) {
        DispatchQueue.main.async() {
            
            WCSession.default.sendMessage(["action": "image", "img-url": imgUrl, "t": title, "c": count
                , "id": id, "width": width, "height": height], replyHandler: nil);
        }
    }
    
    func startLoadingOnWatch() {
        DispatchQueue.main.async() {
            WCSession.default.sendMessage(["action": "loading", "loading": true], replyHandler: nil);
        }
    }
    
    func stopLoadingOnWatch() {
        DispatchQueue.main.async() {
            WCSession.default.sendMessage(["action": "loading", "loading": false], replyHandler: nil);
        }
    }
    
    func pingHotspotsToWatch(hotspotDictionary : [String : [[String : Any]]]) {
        // [String : [[String : Any]]]
        DispatchQueue.main.async() {
            WCSession.default.sendMessage(["action": "hotspots", "hotspots": hotspotDictionary], replyHandler: nil);
        }
    }
    
    func fetchProjectDetails(projectID:String) {
        
        let urlWithParams = "https://marvelapp.com/api/project-retrieve/" + projectID;
        
        
        let myUrl = NSURL(string: urlWithParams);
        
        let request = URLRequest(url: myUrl! as URL)
        do {
            // Perform the request
            var response: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
            let data = try NSURLConnection.sendSynchronousRequest(request, returning: response)
            let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            //            print("responseString = \(responseString)");
            
            //            // Convert the data to JSON
            let json = try JSON(data: data)
            let images = json["images"];
            for (key,subJson):(String, JSON) in images {
                print(subJson["url"]);
                let imgUrl = subJson["url"].stringValue;
                let session = URLSession(configuration: .default)
                
                DispatchQueue.global().async() {
                    let url:URL = URL(string: imgUrl)!
                    var data:NSData = NSData(contentsOf: url)!
                    var image = UIImage(data: data as Data)!
                    self.imageMap[key] = image;
                    var count = images.count;
                    var id : String = subJson["id"].stringValue;
                    var width : Int = subJson["width"].intValue;
                    var height : Int = subJson["height"].intValue;
                    self.pingImageToWatch(imgUrl: imgUrl, title: key, count: count, id: id, width: width, height: height);
                    
                    if (self.imageMap.count == images.count) {
                        self.stopLoadingOnWatch();
                    }
                    
                    print("Pinged img \(key) of \(self.imageMap.count)");
                }
            }
//            let imgOne = images["1"]["url"].stringValue;
            // group.uk.co.daniel-cotton.marvelous
//            storePreference(key: "first-image", value: imgOne);
//            print("Val \(getPreference(key: "first-image"))");
            
        } catch {
            print("Error info: \(error)")
        }
    }
    
    func fetchProjectHotspots(projectID:String) {
        let urlWithParams = "https://marvelapp.com/api/project-hotspots/" + projectID;
        
        
        let myUrl = NSURL(string: urlWithParams);
        
        let request = URLRequest(url: myUrl! as URL)
        do {
            // Perform the request
            var response: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
            let data = try NSURLConnection.sendSynchronousRequest(request, returning: response)
            let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            //            print("responseString = \(responseString)");
            
            //            // Convert the data to JSON
            let json = try JSON(data: data)
            var dict : [String : [[String : Any]]] = [String : [[String : Any]]]();
//            "x": 25,
//            "y": 122,
//            "x2": 295,
//            "y2": 258,

            for (key,subJson):(String, JSON) in json {
                var array : [[String : Any]];
                
                if ((dict[subJson["img_owner_fk"].stringValue]) != nil) {
                    array = dict[subJson["img_owner_fk"].stringValue]!;
                } else {
                    array = [];
                }
                array.append([
                    "id": subJson["id"].stringValue,
                    "destination": subJson["dest_img_fk"].stringValue,
                    "x": subJson["x"].intValue,
                    "y": subJson["y"].intValue,
                    "x2": subJson["x2"].intValue,
                    "y2": subJson["y2"].intValue,
                    "action": subJson["action"].stringValue,
                    "timer": subJson["timer"].floatValue
                ]);
                dict[subJson["img_owner_fk"].stringValue] = array;
            }
            
            pingHotspotsToWatch(hotspotDictionary: dict);
            print("DICT", dict);
            
        } catch {
            print("Error info: \(error)")
        }
    }


    @IBAction func handleSave() {
        let projectID = projectIdField.text
        
        // Check of userNameValue is not empty
        if isStringEmpty(stringValue: projectID!) == true
        {
            return
        }
        startLoadingOnWatch();
        fetchProjectDetails(projectID: projectID!);
        fetchProjectHotspots(projectID: projectID!);
//        let data: Data // received from a network request, for example
//        let json = try? JSONSerialization.jsonObject(with: data, options: [])

    }

}

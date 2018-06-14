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

class ViewController: UIViewController, WCSessionDelegate {
    var current : Int = 1;
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    private var imageMap: [String: UIImage] = [:]
    
    @IBOutlet weak var projectIdField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if WCSession.isSupported() {
            WCSession.default.delegate = self as! WCSessionDelegate
            WCSession.default.activate()
        }
        // Do any additional setup after loading the view, typically from a nib.
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
    
    func getPreference(key: String) -> String {
        let defaults = UserDefaults(suiteName: "group.uk.co.daniel-cotton.marvelous")
        return defaults!.string(forKey: key)!;
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        print("Recieved msg from watch");
        self.current = self.current + 1;
        
        replyHandler(messageData)
    }
    
    func pingImageToWatch(image: UIImage, title : String, count : Int, id : String) {
        DispatchQueue.main.async() {
            
            let data = UIImageJPEGRepresentation(image, 1.0)
            
            WCSession.default.sendMessage(["action": "image", "d": data!, "t": title, "c": count
                , "id": id], replyHandler: nil);
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
                    self.pingImageToWatch(image: image, title: key, count: count, id: id);
                    
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
            let images = json["images"];
            for (key,subJson):(String, JSON) in images {
                print(subJson["url"]);
            }
            
            
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
//        let data: Data // received from a network request, for example
//        let json = try? JSONSerialization.jsonObject(with: data, options: [])

    }

}


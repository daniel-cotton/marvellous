//
//  InterfaceController.swift
//  Marvelous WatchKit Extension
//
//  Created by dcotton on 13/06/2018.
//  Copyright © 2018 dcotton. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var active : Int = 1;
    var imageMap : [String : UIImage] = [:];
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    @IBOutlet var baseImage: WKInterfaceImage!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    func storePreference(key: String, value: String) {
        let defaults = UserDefaults(suiteName: "group.uk.co.daniel-cotton.marvelous")
        defaults?.set(value, forKey: key);
    }
    
    func getPreference(key: String) -> String? {
        let defaults : UserDefaults = UserDefaults(suiteName: "group.uk.co.daniel-cotton.marvelous")!
        return defaults.string(forKey: key);
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self as WCSessionDelegate
            WCSession.default.activate()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        
        guard let image = UIImage(data: messageData) else {
            return
        }
        print("New image");
        // throw to the main queue to upate properly
        DispatchQueue.main.async() { [weak self] in
            // update your UI here
            self?.baseImage.setImage(image);
        }
        
        replyHandler(messageData)
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: @escaping ([String : AnyObject]) -> Void) {
        guard let image = UIImage(data: message["d"] as! Data) else {
            return
        }
        print("New image : \(message["t"])");
        // throw to the main queue to upate properly
        DispatchQueue.main.async() { [weak self] in
            // update your UI here
            self?.baseImage.setImage(image);
        }
        
        replyHandler(message);
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let image = UIImage(data: message["d"] as! Data) else {
            return
        }
        print("New image : \(message["t"])");
        // throw to the main queue to upate properly
        DispatchQueue.main.async() { [weak self] in
            // update your UI here
            var id : String = message["id"] as! String;
            var title : String = message["t"] as! String;
            var strRep : String = "\(self!.active)";
//            var count : String = message["c"] as! Number;
            if (title == strRep) {
                self?.baseImage.setImage(image);
            }
            print("Count: \(message["c"]) - Img# \(message["t"])")
            self?.imageMap[title] = image;
        }
        
    }
    @IBAction func next() {
        print("Calling next");
        self.active = self.active + 1;
        var strRep : String = "\(self.active)";
        self.baseImage.setImage(imageMap[strRep]);
    }
    


}

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
    
    @IBOutlet var loadingSpinner : WKInterfaceImage!;
    @IBOutlet var baseImage: WKInterfaceImage!
    @IBOutlet var group : WKInterfaceGroup!;
    var active : Int = 1;
    var imageMap : [String : UIImage] = [:];
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    @IBAction func handleGesture(gestureRecognizer : WKGestureRecognizer) {
        print("TAP", gestureRecognizer.locationInObject());
    }
    
    func handleClick() {
        
    }
    func segueToScreen(screenId : String) {
        
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        loadingSpinner.setImageNamed("Activity");
        loadingSpinner.setHidden(true);
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
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        let action : String = message["action"] as! String;
        print("Using action \(action)");
        if (action == "loading") {
            let isLoading : Bool = message["loading"] as! Bool;
            loadingSpinner.setHidden(!isLoading);
            if (isLoading) {
                loadingSpinner.startAnimating();
            } else {
                loadingSpinner.stopAnimating();
            }
        } else {
            print("In else");
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
        
    }
    @IBAction func next() {
        print("Calling next");
        self.active = self.active + 1;
        var strRep : String = "\(self.active)";
        self.baseImage.setImage(imageMap[strRep]);
    }
    


}

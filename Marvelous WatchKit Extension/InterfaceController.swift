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
    var imageSizes : [String : [Int]] = [:];
    var hotspots : [String : [[String : Any]]] = [:];
    var activeScreen : String = "";
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    @IBAction func handleGesture(gestureRecognizer : WKGestureRecognizer) {
        
        let resolvedTap : CGPoint = resolveXYTap(gestureRecognizer: gestureRecognizer);
        print("TAP", resolvedTap);
        handleClick(click: resolvedTap);
    }
    func resolveXYTap(gestureRecognizer : WKGestureRecognizer) -> CGPoint {
        let viewBounds : CGRect = gestureRecognizer.objectBounds();
        let tapLocation : CGPoint = gestureRecognizer.locationInObject();
        let finalTap : CGPoint = CGPoint(x: tapLocation.x / viewBounds.width, y: tapLocation.y / viewBounds.height);
        return finalTap;
    }
    
    func handleClick(click : CGPoint) {
        print("Click here:", click);
        var pageHotspots : [[String : Any]] = self.hotspots[activeScreen]!;
        let screenSizes : [Int] = self.imageSizes[activeScreen]!;
        print("Hotspots for current page: ", pageHotspots);
        
        for (hotspot) : ([String : Any]) in pageHotspots {
            let hotspotX : CGFloat = CGFloat(hotspot["x"] as! Int);
            let hotspotX2 : CGFloat = CGFloat(hotspot["x2"] as! Int);
            let hotspotY : CGFloat = CGFloat(hotspot["y"] as! Int);
            let hotspotY2 : CGFloat = CGFloat(hotspot["y2"] as! Int);
            let hotspotRect : CGRect = CGRect(x: hotspotX, y: hotspotY, width: hotspotX2 - hotspotX, height: hotspotY2 - hotspotY);
            let relativeHotspot : CGRect = CGRect(
                x: hotspotRect.minX / CGFloat(screenSizes[0]),
                y: hotspotRect.minY / CGFloat(screenSizes[1]),
                width: hotspotRect.width / CGFloat(screenSizes[0]),
                height: hotspotRect.height / CGFloat(screenSizes[1]));
            print("Relative Hotspot", hotspotRect, relativeHotspot);
            if (click.x >= relativeHotspot.minX &&
                click.y >= relativeHotspot.minY &&
                click.x <= relativeHotspot.maxX &&
                click.y <= relativeHotspot.maxY) {
                let destination : String = hotspot["destination"] as! String;
                print("Valid Hotspot, going to page", destination);
                segueToScreen(screenId: destination);
            }
        }
        //
    }
    func segueToScreen(screenId : String) {
        let image : UIImage = imageMap[screenId]!;
        activeScreen = screenId;
        self.baseImage.setImage(image);
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
        } else if (action == "hotspots") {
            hotspots = message["hotspots"] as! [String : [[String : Any]]];
            print("Received Hotspots", hotspots);
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
                let width : Int = message["width"] as! Int;
                let height : Int = message["height"] as! Int;
                //            var count : String = message["c"] as! Number;
                print("Count: \(message["c"]) - Img# \(message["t"])")
                self?.imageMap[id] = image;
                self?.imageSizes[id] = [width, height];
                if (title == "1") {
                    self?.segueToScreen(screenId: id);
                }
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

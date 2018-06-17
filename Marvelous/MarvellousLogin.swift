//
//  MarvellousLogin.swift
//  Marvelous
//
//  Created by dcotton on 17/06/2018.
//  Copyright © 2018 dcotton. All rights reserved.
//

import UIKit
import Foundation

let marvelClientID : String = ProcessInfo.processInfo.environment["MARVEL_CLIENT_ID"]!;
let marvelClientSecret : String = ProcessInfo.processInfo.environment["MARVEL_CLIENT_SECRET"]!;

class MarvellousLogin: UIViewController {
    @IBAction func loginClicked() {
        print("ID: ", marvelClientID, marvelClientSecret);
        let urlString : String = ("https://marvelapp.com/oauth/authorize?client_id=" + marvelClientID + "&response_type=token&redirect_uri=https%3A%2F%2Fus-central1-marvellous-dae2a.cloudfunctions.net%2Fcallback&scope=user:read%20projects:read");
        print(urlString);
        guard let url = URL(string: urlString) else {
            return //be safe
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        let token = getPreference(key: "access_token");
        print(getPreference(key: "access_token"), token.isEmpty)
        if (token.isEmpty == false) {
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    func storePreference(key: String, value: String) {
        let defaults = UserDefaults(suiteName: "group.uk.co.daniel-cotton.marvelous")
        defaults?.set(value, forKey: key);
    }
    
    func getPreference(key: String) -> String {
        let defaults = UserDefaults(suiteName: "group.uk.co.daniel-cotton.marvelous")
        return defaults!.string(forKey: key)!;
    }
    public func handleReturn(message: String, query: String) {
        print("Returned: ", message, " - ", query);
        let params = query.split(separator: "&");
        var query : [String : String] = [:];
        
        for (param) in params {
            let splitParam = param.split(separator: "=");
            if (splitParam.count > 1) {
                query[String(splitParam[0])] = String(splitParam[1]);
            }
        }
        storePreference(key: "access_token", value: query["access_token"]!);
        storePreference(key: "token_type", value: query["token_type"]!);
//        print("Ret pref", getPreference(key: "access_token"));
        self.performSegue(withIdentifier: "loginSegue", sender: self)
    }
}

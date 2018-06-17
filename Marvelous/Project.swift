//
//  Project.swift
//  Marvelous
//
//  Created by dcotton on 17/06/2018.
//  Copyright © 2018 dcotton. All rights reserved.
//

import Foundation
import UIKit

struct Project : Hashable {
    let projectName: String;
    let image: UIImage;
    let prototypeId: String;
    let createdDate: Date;
    
    var hashValue: Int {
        return projectName.hashValue
    }

    init(project: String, imgUrl: String, prototypeUrl: String, createdDate: String) {
        self.projectName = project;
        let url:URL = URL(string: imgUrl)!
        print(imgUrl, url);
        let data:NSData = NSData(contentsOf: url)!
        self.image = UIImage(data: data as Data)!
        prototypeId = prototypeUrl.replacingOccurrences(of: "https://marvelapp.com/", with: "");
        print(prototypeId);
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter.date(from:createdDate)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        self.createdDate = calendar.date(from:components)!;
    }
}

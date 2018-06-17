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
    var hashValue: Int {
        return projectName.hashValue
    }

    init(project: String, imgUrl: String) {
        self.projectName = project;
        let url:URL = URL(string: imgUrl)!
        print(imgUrl, url);
        let data:NSData = NSData(contentsOf: url)!
        self.image = UIImage(data: data as Data)!
    }
}

//
//  CollectionViewCard.swift
//  Marvelous
//
//  Created by dcotton on 17/06/2018.
//  Copyright © 2018 dcotton. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewCard: UICollectionViewCell {
    @IBOutlet var image: UIImageView!;
    @IBOutlet var title: UILabel!;
    @IBOutlet var cardView: UIView!;
    @IBOutlet public var clickableRow: UIView!;
    
    func displayContent(project: Project) {
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = CGSize.zero
        cardView.layer.shadowRadius = 2
        cardView.layer.shadowPath = UIBezierPath(rect: cardView.bounds).cgPath;
        
        title.text = project.projectName;
        image.image = project.image;
    }
}

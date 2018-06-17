//
//  LandingScene.swift
//  Marvelous WatchKit Extension
//
//  Created by dcotton on 17/06/2018.
//  Copyright © 2018 dcotton. All rights reserved.
//

import Foundation
import SpriteKit
class LandingScene : SKScene {
    override func sceneDidLoad() {
        let title : SKLabelNode = SKLabelNode(text: "Marvellous");
        title.fontSize = 23;
        title.position = CGPoint(x: 10, y: self.size.height - 40);
        title.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left;
        let description : SKLabelNode = SKLabelNode(text: "Launch Marvellous on your iPhone to sync a project to your watch");
        description.fontSize = 12;
        description.position = CGPoint(x: 10, y: self.size.height - 60);
        description.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left;
        description.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top;
        description.numberOfLines = 0
        description.preferredMaxLayoutWidth = self.size.width - 20;

        addChild(title);
        addChild(description);
    }
    override init(size : CGSize) {
        
        super.init(size: size);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

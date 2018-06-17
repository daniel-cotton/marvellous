//
//  SKRenderer.swift
//  Marvelous WatchKit Extension
//
//  Created by dcotton on 17/06/2018.
//  Copyright © 2018 dcotton. All rights reserved.
//

import Foundation;
import SpriteKit;
import SpriteKit.SKView;

class SKRenderer : SKScene {
    let label = SKLabelNode(text: "Hello SpriteKit!")
    var Sprite : SKSpriteNode? = nil;
    public func setTexture(image: UIImage) {
        let Texture = SKTexture(image: image)
        Sprite = SKSpriteNode(texture: Texture);
        Sprite?.size = CGSize(width: self.size.width, height: self.size.height);
        Sprite?.position = CGPoint(x: self.size.width/2, y: self.size.height/2);
        addChild(Sprite!);
        print("Setting texture", Sprite);
    }
    override init(size : CGSize) {
        
        super.init(size: size);
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

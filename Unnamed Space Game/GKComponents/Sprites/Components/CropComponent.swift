//
//  CropSpriteComp.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 17/3/21.
//

import SpriteKit
import GameplayKit


//
class CropComponent: GKComponent {
    
    //
    let cropNode = SKCropNode()
    static let cropKey: String = "cropnode"
    
    //
    var maskNode: SKSpriteNode? {
        if let node = cropNode.maskNode as? SKSpriteNode { return node } else { return nil }
    }
    static let maskNodeKey = "masknode"
    
    
    init(maskNode: SKNode? = nil) {
        super.init()
        cropNode.maskNode = maskNode
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
}

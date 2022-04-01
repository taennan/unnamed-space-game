//
//  SpriteComp.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 17/3/21.
//

import SpriteKit
import GameplayKit


//
class SpriteComponent: GKComponent {
    
    // Base node
    let node = SKNode()
    
    // Allows easy access to any SKSpriteNode() used as the background of the sprite component
    static let baseKey: String = "base"
    var base: SKSpriteNode? {
        return node.childNode(withName: SpriteComponent.baseKey) as? SKSpriteNode
    }
    
    
}

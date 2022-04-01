//
//  GameDisplay.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 26/7/21.
//

import SpriteKit
import GameplayKit

//
class GameDisplay: Display {
    
    //
    weak var gamescene: GameScene? { return spriteComp.node.scene as? GameScene }
    //
    override weak var scene: UnSGScene? {
        fatalError("Attempted to use 'scene' proerty in GameDisplay object. Use 'gamescene' property instead")
    }
    
    
}

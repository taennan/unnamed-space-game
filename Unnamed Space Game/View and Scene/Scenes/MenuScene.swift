//
//  MenuScene.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 14/5/21.
//

import SpriteKit


//
class MenuScene: UnSGScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setDisplays([Display(.west),
                     GameMenuDisplay(),
                     Display(.east),
                     MainMenuDisplay()])
    }
    
    
}

//
//  ScrollBar.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 2/5/21.
//


//import GameplayKit
import SpriteKit


//
class ScrollBar: Button {
    
    // So that the state can be set without changing textures
    override func setState(_ state: Button.State) {
        
        currentState = state
        if state == .inactive {
            interactionEnabled = false
        } else {
            interactionEnabled = true
        }
    }
    
    // Overriden so that the command can be run without changing state
    override func mouseDown() {
        guard interactionEnabled else { return }
        commandComp.runCommand()
    }
    
    
}

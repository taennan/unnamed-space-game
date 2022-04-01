//
//  ButtonSpriteComponent.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 11/5/21.
//

import SpriteKit


// A sprite component that allows easy access to certain sprites within the button
class ButtonSpriteComponent: SpriteComponent {
    
    // Returns the interactive sprite (if any...) which also acts as the buttons' body
    var body: InteractiveSprite? {
        return self.node.childNode(withName: Button.bodyKey) as? InteractiveSprite
    }
    // Returns the label (if any...)
    var label: SKLabelNode? {
        return self.node.childNode(withName: Button.labelKey) as? SKLabelNode
    }
    //
    var icon: SKSpriteNode? {
        return self.node.childNode(withName: Button.iconKey) as? SKSpriteNode
    }
    
}

// These were made so that button colours can be easily fiddled with
extension Colours {
    
    //
    static func buttonLabelColour(forState state: Button.State) -> NSColor {
        switch state {
        case .on:
            return Colours.white
        case .off:
            return Colours.lightGrey
        case .hoverOn:
            return Colours.white
        case .hoverOff:
            return Colours.lightGrey
        case .inactive:
            return Colours.lightGrey
        }
    }
    
}

extension SKTexture {
    
    // Backgrounds
    class func buttonBaseTexture(forState state: Button.State) -> SKTexture {
        let texture = (state == .inactive) ? SKTexture.square(.grey, .dark) : SKTexture.square(.white)
        return texture
    }
    // Main body
    class func buttonBodyTexture(forState state: Button.State) -> SKTexture {
        
        switch state {
        case .on:
            return SKTexture.square(.grey, .dark)
        case .off:
            return SKTexture.square(.grey, .dark)
        case .hoverOn:
            return SKTexture.square(.grey)
        case .hoverOff:
            return SKTexture.square(.grey)
        case .inactive:
            return SKTexture.square(.grey, .dark)
        }
        
    }
    
}

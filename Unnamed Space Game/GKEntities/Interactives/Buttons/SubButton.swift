//
//  SubButton.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 4/6/21.
//

import SpriteKit


//
class SubButton: Button {
    
    let index: Int
    
    init(_ index: Int, size: CGSize,
         // Preset argument
        handlesMouseEvents: [InteractiveSprite.MouseEvents]? = [.mouseDown, .mouseUp, .mouseMoved],
        borderWidth: CGFloat = 0) {
        self.index = index
        super.init(size: size, handlesMouseEvents: handlesMouseEvents, borderWidth: borderWidth)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // Overriden because sub-buttons do not ever need to be set to hover on
    override func mouseMovedIn() {
        guard interactionEnabled else { return }
        
        if currentState == .off {
            setState(.hoverOff)
        }
        
        isPressed = false
    }
    
    
}

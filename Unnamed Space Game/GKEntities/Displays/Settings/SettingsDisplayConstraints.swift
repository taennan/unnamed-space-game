//
//  SettingsDisplay.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 12/8/21.
//

import SpriteKit

// St
struct SettingsDisplayConstraints {
    
    private init() { fatalError("SettingsDisplay object is not meant to be intitialised") }
    
    private static let size: CGSize  = Display.size(ofPole: .west)
    
    static let buttonSize:   CGSize  = CGSize(width: size.width * 0.2, height: size.height * 0.05)
    static let xOffset:      CGFloat = (-size.width / 2) + (size.width * 0.1)
    static let labelSpacing: CGFloat = size.height * 0.05
    static let labelHeight:  CGFloat = buttonSize.height * 0.7
    static let labelConstraint: SKLabelNode.SizeConstraint = .height(buttonSize.height * 0.7)
    
}

struct SDC {
    
    let buttonSize:   CGSize
    let xOffset:      CGFloat
    let labelSpacing: CGFloat
    let labelConstraint: SKLabelNode.SizeConstraint
    
    init() {
        
        let size = Display.size(ofPole: .west)
        
        self.buttonSize = CGSize(width: size.width * 0.2, height: size.height * 0.05)
        self.xOffset    = (-size.width / 2) + (size.width * 0.1)
            
        self.labelSpacing    = size.height * 0.05
        self.labelConstraint = .height(buttonSize.height * 0.7)
        
    }
    
}

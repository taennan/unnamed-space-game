//
//  InteractiveProtocols.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 16/3/21.
//

import SpriteKit

//
enum PositionalAlignment {
    case left
    case right
    case center
    case top
    case bottom
}

// Adds helpful properties
protocol InteractiveEntity {
    
    var borderWidth: CGFloat { get }
    var interactionEnabled: Bool { get set }
    
}

//
enum Switch {
    case active
    case inactive
}
protocol IsTwoState {
    
    var currentState: Switch { get set }
    func setState(_: Switch)
    
}

// Adds handler functions to run actions when the conforming entity is interacted with
protocol RespondsToMouseEvents {
    
    // For mouse left clicks
    func mouseDown()
    func mouseUp()
    // For mouse movements within and without the entity
    func mouseMovedIn()
    func mouseMovedOut()
}

// Adds functionality to do what it says
protocol RespondsToScrollEvents {
    
    // Runs actions based on scrolling delta y value
    func scrollWheel(by: CGFloat)
}

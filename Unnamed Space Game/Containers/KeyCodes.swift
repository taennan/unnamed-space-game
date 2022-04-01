//
//  KeyCodes.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 16/12/20.
//

import SpriteKit


// Stores all hexadecimal keycodes used in-game
/// TODO: Fill out any other needed keys
struct KeyCodes {
    
    // Player One
    static let w: UInt16 = 0x0d            // -----+
    static let s: UInt16 = 0x01            //      |
                                           //      |--- Controls ship thrusters
    static let a: UInt16 = 0x00            //      |
    static let d: UInt16 = 0x02            // -----+
    
    static let q: UInt16 = 0x0c            // --------- Controls autopilot
    static let e: UInt16 = 0x0e            // ---|      (maybe try c and v?)
    
    static let spacebar: UInt16 = 0x31     // --------- Fires cannon (maybe try left shift?)
    
    
    // Player Two
    static let up: UInt16 = 0x7e           // -----+
    static let down: UInt16 = 0x7d         //      |
                                           //      | --- Controls ship thrusters
    static let left: UInt16 = 0x7b         //      |
    static let right: UInt16 = 0x7c        // -----+
    
    static let num0: UInt16 = 0x52         // ---------- Controls autopilot
    static let numDot: UInt16 = 0x41       // ---|
    
    static let numEnter: UInt16 = 0x4c     // ---------- Fires cannon
    
    
}

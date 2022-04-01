//
//  Bitmasks.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 30/3/21.
//


// UInt32 values for use by physics components
/// TODO: Fill out any others that are needed
struct Bitmasks {
    
    //
    static let on: UInt32   = ~0x0
    static let off: UInt32  = 0x0
    
    // Starships
    static let starship: UInt32     = 0x1 << 0
    static let projectile: UInt32   = 0x1 << 1
    static let towCable: UInt32     = 0x1 << 2
    static let shield: UInt32       = 0x1 << 3
    
    // Heavenly Bodies
    static let edgeBody: UInt32     = 0x1 << 4          // Map borders
    static let volumeBody: UInt32   = 0x1 << 5          // Meteors and stuff
    static let staticBody: UInt32   = 0x1 << 6          // Planets, Suns, Black Holes
    
    // Fields
    static let gravField: UInt32    = 0x1 << 7
    static let magField: UInt32     = 0x1 << 8
    static let dragField: UInt32    = 0x1 << 9
    
    
    // Uses an OR operator to set each corresponding bit in hexadecimal sequences
    static func combine(_ bitmasks: [UInt32]) -> UInt32 {
        
        var mask: UInt32 = Bitmasks.off
        for hex in bitmasks { mask |= hex }
        
        return mask
    }
    
    
}

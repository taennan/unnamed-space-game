//
//  Colours.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 30/6/21.
//

import SpriteKit

// Did not put this in the 'Extensions' group as I'll only risk using it in this file
fileprivate extension NSColor {
    
    // Created for easy instantiation from Affinity Designer RGB graph values
    /// Parameters initialisable with values from 0...255
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        guard (red >= 0 && red <= 255) &&
              (green >= 0 && green <= 255) &&
              (blue >= 0 && blue <= 255)
            else { fatalError("Expected RGB values to be within 0...255, got \(red, green, blue)") }
        
        // Converts values to be within 0...1
        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
}

// Contains NSColor objects to colour labels and shape nodes with
struct Colours {
    
    // Greyscales
    static let white        = NSColor(white: 1,    alpha: 1)
    static let nearWhite    = NSColor(white: 0.9,  alpha: 1)
    
    static let lightGrey    = NSColor(white: 0.75, alpha: 1)
    static let grey         = NSColor(white: 0.5,  alpha: 1)
    static let darkGrey     = NSColor(white: 0.25, alpha: 1)
    
    static let nearBlack    = NSColor(white: 0.1,  alpha: 1)
    static let black        = NSColor(white: 0,    alpha: 1)
    
    // RGBs
    // - All these are initialised with the convenience init declared above
    static let teamColour: [SKTexture.TeamColours: NSColor] =
        [.red:      NSColor(red: 191, green: 64_, blue: 64),
         .orange:   NSColor(red: 191, green: 128, blue: 64),
         .yellow:   NSColor(red: 191, green: 191, blue: 64),
         .olive:    NSColor(red: 127, green: 191, blue: 64),
         .green:    NSColor(red: 64_, green: 191, blue: 64),
         .teal:     NSColor(red: 64_, green: 191, blue: 127),
         .cyan:     NSColor(red: 64_, green: 191, blue: 191),
         .blue:     NSColor(red: 64_, green: 128, blue: 191),
         .violet:   NSColor(red: 64_, green: 64_, blue: 191),
         .purple:   NSColor(red: 128, green: 64_, blue: 191),
         .magenta:  NSColor(red: 191, green: 64_, blue: 191),
         .scarlet:  NSColor(red: 191, green: 64_, blue: 127)]
    
    // Grabs the colour of the team specified and returns the
    // appropriate NSColor() object from the above dictionary
    static func getColour(forTeam team: Team) -> NSColor {
        let colour = Settings.Starships.colours.get(team).value
        return Colours.teamColour[colour]!
    }
    
    
}

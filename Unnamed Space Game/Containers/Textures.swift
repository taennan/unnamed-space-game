//
//  Textures.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 9/12/20.
//

import SpriteKit


// Contains preloaded textures which can be accessed and used by game entities
/// UNCOMMENT IF NEEDED
/*
struct Textures {
    
    static let display = SKTexture.square(.grey, .dark)
    
    // Stores textures which can be accessed by passing the name of the image used by the SKTexture() object
    static var preloads: [String: SKTexture] = [:]
    
    // Adds textures of specified names to the above dictionary
    static func preloadTextures(withNames names: [String]) {
        for name in names { Textures.preloads[name] = SKTexture(imageNamed: name) }
    }
    
    // Calls preloadTextures() with names of textures needed for button and display entities
    static func preloadButtonAndDisplayTextures() {
        let names = ["BlackSquare",     /// <--- These names are subject to change
                     "GreyDarkestSquare",
                     "GreyDarkSquare",
                     "GreySquare",
                     "WhiteSquare"]
        Textures.preloadTextures(withNames: names)
    }
    
    // Calls preloadTextures() for starship textures of specified colour
    static func preloadStarshipTextures(forColours colours: [SKTexture.Colours]) {
        let legitColours = colours.filter { $0 != SKTexture.Colours.black ||
                                            $0 != SKTexture.Colours.grey ||
                                            $0 != SKTexture.Colours.white }
        let names = legitColours.map { "\($0.rawValue)Starship" }
        Textures.preloadTextures(withNames: names)
    }
    
    
}
*/

// Allows easy instantiation of textures
extension SKTexture {
    
    // Contains strings used to access custom textures
    
    // Lists all available colours
    enum Colours: String, CaseIterable {
        case white      = "White"
        case grey       = "Grey"
        case black      = "Black"
        
        case red        = "Red"
        case orange     = "Orange"
        case yellow     = "Yellow"
        case olive      = "Olive"
        case green      = "Green"
        case teal       = "Teal"
        case cyan       = "Cyan"
        case blue       = "Blue"
        case violet     = "Violet"
        case purple     = "Purple"
        case magenta    = "Magenta"
        case scarlet    = "Scarlet"
    }
    // All colours available for starships
    enum TeamColours: String, CaseIterable {
        case red        = "Red"
        case orange     = "Orange"
        case yellow     = "Yellow"
        case olive      = "Olive"
        case green      = "Green"
        case teal       = "Teal"
        case cyan       = "Cyan"
        case blue       = "Blue"
        case violet     = "Violet"
        case purple     = "Purple"
        case magenta    = "Magenta"
        case scarlet    = "Scarlet"
    }
    // Lists all available shapes
    enum Shapes: String {
        case square     = "Square"
        case circle     = "Circle"
        case triangle   = "Triangle"
    }
    // Lists all available shades of a colour
    enum Shades: String, CaseIterable {
        case lightest   = "Lightest"
        case light      = "Light"
        case none       = ""
        case dark       = "Dark"
        case darkest    = "Darkest"
    }
    
    
    // One method is for instantiating starship textures from the colour specified in Settings, the other is for instantiating with an explicit colour
    // - It is recommended to use the former
    class func starship(forPlayer player: Team) -> SKTexture {
        let colour = Settings.Starships.colours.get(player).value
        return SKTexture(imageNamed: "\(colour.rawValue)Starship")
    }
    class func starship(ofColour colour: TeamColours) -> SKTexture {
        return SKTexture(imageNamed: "\(colour.rawValue)Starship")
    }
    
    // Returns a circle texture matching the colour of the given team
    class func projectile(fromTeam team: Team) -> SKTexture {
        let colour = Settings.Starships.colours.get(team).value
        return SKTexture(imageNamed: "\(colour.rawValue)\(Shapes.circle.rawValue)")
    }
    
    // Returns shape textures
    class func circle(_ colour: Colours, _ shade: Shades = .none) -> SKTexture {
        return SKTexture(imageNamed: "\(colour.rawValue)\(shade.rawValue)\(Shapes.circle.rawValue)")
    }
    class func square(_ colour: Colours, _ shade: Shades = .none) -> SKTexture {
        return SKTexture(imageNamed: "\(colour.rawValue)\(shade.rawValue)\(Shapes.square.rawValue)")
    }
    class func triangle(_ colour: Colours, _ shade: Shades = .none) -> SKTexture {
        return SKTexture(imageNamed: "\(colour.rawValue)\(shade.rawValue)\(Shapes.triangle.rawValue)")
    }
    
    
    enum CustomImages: String {
        case pauseLabel = "PauseLabel"
        case playLabel  = "PlayLabel"
    }
    
    class func customImage(_ image: CustomImages) -> SKTexture {
        return SKTexture(imageNamed: image.rawValue)
    }
    
}

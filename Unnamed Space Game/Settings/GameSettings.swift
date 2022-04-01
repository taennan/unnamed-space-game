//
//  GameSettTwo.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 26/6/21.
//


// Contains all the values used to determine the rules and behaviour of the game
// - The rest of the functionality is added via extensions
struct Settings {
    
    static func resetToDefualts() {
        Settings.Game.resetToDefualts()
        Settings.Starships.resetToDefualts()
    }
    
}

//
extension Settings {
    
    static var Game = GameSettings()
    
    struct GameSettings {
        
        // Allows this object to only be instantiated by the enclosing structure
        fileprivate init() {}
        
        // Re-instantiates self to reset all properties
        mutating func resetToDefualts() { self = GameSettings() }
        
        
        // Whether projectiles fired from starships can destroy the starship
        var friendlyFire        = Collection(contents: [true, false])
        // Whether projectiles can destroy each other on contact
        var projectilesCollide  = Collection(contents: [true, false])
        
        // Total wins or rounds a player must get to end the game
        var maxPoints           = Collection(defualtIndex: 1, contents: [1,3,5])
        
        // The game mode
        // - Added raw values for use by radio buttons or selectors
        enum GameMode: String, CaseIterable {
            case firstTo = "FIRST TO"
            case bestOf  = "BEST OF"
        }
        var gameMode = Collection(contents: [GameMode.firstTo, GameMode.bestOf])
        
        // Returns the type of the current map
        var map: Map.Type { return allMaps[mapIndex] }
        
        // Could not use a Collection for this one as they are incompatible with Types
        /// TODO: Fill out all other map types as options
        var mapIndex: Int = 0
        let allMaps: [Map.Type] = [DeepSpaceMap.self,
                                   LonelyPlanetMap.self]
        
        mutating func setMap(to maptype: Map.Type) {
            if let index =  allMaps.firstIndex(where: { $0 == maptype }) {
                self.mapIndex = index
            } else {
                print("ERROR: No map of type \(maptype) added to 'allMaps' array in Game Settings")
            }
        }
        
    }
    
}

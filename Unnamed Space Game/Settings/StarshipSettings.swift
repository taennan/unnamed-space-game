//
//  StarshipSettTwo.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 26/6/21.
//

import SpriteKit

//
extension Settings {
    
    static var Starships = StarshipSettings()
    
    struct StarshipSettings {
        
        // Whenever set to true, the values of all other options will be equalised
        var areEqual: Bool = true {
            didSet {
                if areEqual { self.equalisePlayers() }
            }
        }
        
        // Total sections shields are divided into
        var shieldSections:         Pair<Collection<Int>>
        // HP of players' shields
        var shieldHP:               Pair<Collection<Int>>
        // If set to true, the shields (if feasable) are
        // rotated to protect different quarters of the ship
        var shieldsAreOffset:       Pair<Collection<Bool>>
        
        // Maximum shots stored in magazine
        var cannonCapacity:         Pair<Collection<Int>>
        // Time taken for one shot to recharge
        var cannonRechargeTime:     Pair<Collection<TimeInterval>>
        
        // Time taken for a charging projectile to increase power by one stage
        var projectileChargeTime:   Pair<Collection<TimeInterval>>
        // Maximum shots stored within a mega-blast (yes... the name is STC)
        var projectileMaxCharge:    Pair<Collection<Int>>
        
        // Maximum fuel stored in the tank
        var fuelCapacity:           Pair<Collection<CGFloat>>
        // Time taken for one fuel point to recharge
        var fuelChargeTime:         Pair<Collection<TimeInterval>>
        
        // Time taken for cockpit instruments to update
        var cockpitUpdateTime:      Pair<Collection<TimeInterval>>
        
        // The team colours
        var colours:                Pair<Collection<SKTexture.TeamColours>>
        
        
        // Allows this object to only be instantiated by the enclosing structure
        fileprivate init() {
            
            self.shieldSections         = Pair(of: Collection(defualtIndex: 0, contents: [0, 1, 2, 3, 4]))
            self.shieldHP               = Pair(of: Collection(defualtIndex: 0, contents: [0, 1, 2, 3, 4, 5]))
            self.shieldsAreOffset       = Pair(of: Collection(defualtIndex: 0, contents: [true, false]))
            
            self.cannonCapacity         = Pair(of: Collection(defualtIndex: 0, contents: [10, 15, 20, 25]))
            self.cannonRechargeTime     = Pair(of: Collection(defualtIndex: 0, contents: [0, 1, 2, 3]))
            
            self.projectileChargeTime   = Pair(of: Collection(defualtIndex: 0, contents: [1, 2, 3]))
            self.projectileMaxCharge    = Pair(of: Collection(defualtIndex: 0, contents: [3, 4, 5]))
            
            self.fuelCapacity           = Pair(of: Collection(defualtIndex: 0, contents: [10, 15, 20, 25]))
            self.fuelChargeTime         = Pair(of: Collection(defualtIndex: 0, contents: [0, 1, 2, 3]))
            
            self.cockpitUpdateTime      = Pair(of: Collection(defualtIndex: 1, contents: [0, 0.3, 0.5]))
            
            self.colours = Pair(Collection(defualtIndex: 7, contents: SKTexture.TeamColours.allCases),
                                Collection(defualtIndex: 0, contents: SKTexture.TeamColours.allCases))
            colours.one.mutuallyLink(&colours.two)
        }
        
        // Re-instantiates self to reset all properties
        mutating func resetToDefualts() { self = StarshipSettings() }
        
        // Yes, done the hard way... again
        private mutating func equalisePlayers() {
            
            self.shieldSections.equaliseElements(toValueFrom: .one)
            self.shieldHP.equaliseElements(toValueFrom: .one)
            self.shieldsAreOffset.equaliseElements(toValueFrom: .one)
            
            self.cannonCapacity.equaliseElements(toValueFrom: .one)
            self.cannonRechargeTime.equaliseElements(toValueFrom: .one)
            
            self.projectileChargeTime.equaliseElements(toValueFrom: .one)
            self.projectileMaxCharge.equaliseElements(toValueFrom: .one)
            
            self.fuelChargeTime.equaliseElements(toValueFrom: .one)
            self.fuelChargeTime.equaliseElements(toValueFrom: .one)
            
        }
        
    }
    
    
}

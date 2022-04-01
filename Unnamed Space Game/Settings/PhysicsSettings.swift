//
//  PhysSettingsTwo.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 26/6/21.
//

import SpriteKit

//
extension Settings {
    
    static let Physics = PhysicsSettings()
    
    struct PhysicsSettings {
        
        // Allows this object to only be instantiated by the enclosing structure
        fileprivate init() {}
        
        // Starship Velocities
        let fowardThrusterImpulse:   CGFloat = 1000
        let angularThrusterImpulse:  CGFloat = 0.3
        let rearThrusterImpulse:     CGFloat = -500
        
        // Projectile Velocity
        let projectileImpulse:       CGFloat = 20
        
        // Object Masses
        let starshipMass:            CGFloat = 100
        let projectileMass:          CGFloat = 0.5

    }
}

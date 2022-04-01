//
//  SKPhysicsBodyExtensions.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 28/5/21.
//

import SpriteKit


extension SKPhysicsBody {
    
    // Convienience method for setting the values of the bitmasks
    func setBitmasks(category: UInt32, collision: [UInt32], contact: [UInt32], field: [UInt32]) {
        
        self.isDynamic = true
        self.categoryBitMask    = category
        self.contactTestBitMask = Bitmasks.combine(contact)
        self.collisionBitMask   = Bitmasks.combine(collision)
        self.fieldBitMask       = Bitmasks.combine(field)
        
    }
    
    // For easy property setting
    func setProperties(mass: CGFloat, charge: CGFloat, friction: CGFloat, restitution: CGFloat,
                       linearDamping: CGFloat, angularDamping: CGFloat) {
        
        self.restitution      = restitution
        self.friction         = friction
        self.linearDamping    = linearDamping
        self.angularDamping   = angularDamping
        self.charge           = charge
        self.mass             = mass
        
    }
    
    //
    // NOTE: Can't use switch here
    func setProperties(asEntityType type: GameEntity.Type) {
        
        if type == Starship.self {
            setProperties(mass: 100,
                          charge: 0,
                          friction: 0,
                          restitution: 1,
                          linearDamping: 0,
                          angularDamping: 0)
            setBitmasks(category:   Bitmasks.starship,
                        collision:  [Bitmasks.edgeBody, Bitmasks.staticBody],
                        contact:    [Bitmasks.projectile, Bitmasks.volumeBody, Bitmasks.starship,
                                     Bitmasks.edgeBody],
                        field:      [Bitmasks.gravField, Bitmasks.magField, Bitmasks.dragField])
            
        } else if type == Projectile.self {
            setProperties(mass: 0.5,
                          charge: 1,
                          friction: 0,
                          restitution: 1,
                          linearDamping: 0,
                          angularDamping: 0)
            setBitmasks(category:   Bitmasks.projectile,
                        collision:  [Bitmasks.edgeBody],
                        contact:    [Bitmasks.volumeBody, Bitmasks.starship, Bitmasks.shield,
                                     Bitmasks.staticBody, Bitmasks.edgeBody],
                        field:      [Bitmasks.gravField, Bitmasks.magField])
            
        } else if type == Meteor.self {
            setBitmasks(category:   Bitmasks.volumeBody,
                        collision:  [Bitmasks.edgeBody],
                        contact:    [Bitmasks.projectile, Bitmasks.starship, Bitmasks.volumeBody],
                        field:      [Bitmasks.gravField, Bitmasks.dragField])
            
        } else if type == Shield.self {
            setBitmasks(category:   Bitmasks.shield,
                        collision:  [Bitmasks.off],
                        contact:    [Bitmasks.projectile],
                        field:      [Bitmasks.off])
            
        } else if type == Planet.self {
            setBitmasks(category:   Bitmasks.staticBody,
                        collision:  [Bitmasks.on ^ Bitmasks.edgeBody],
                        contact:    [Bitmasks.projectile],
                        field:      [Bitmasks.off])
            
        }
        
    }
    
}


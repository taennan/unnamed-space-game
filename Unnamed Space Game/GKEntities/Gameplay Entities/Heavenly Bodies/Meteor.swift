//
//  Meteor.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 7/5/21.
//

import SpriteKit
import GameplayKit


//
class Meteor: GameEntity {
    
    //
    var hp: Int = 0
    
    init(radius: CGFloat, texture: SKTexture, hp: Int = Int.random(in: 2...4)) {
        
        self.hp = hp
        
        super.init()
        
        if radius > 0 {
            // Creates a circular texture and physics body for the planets' surface
            let background      = SKSpriteNode()
            background.texture  = texture
            background.size     = CGSize(width: radius, height: radius)
            background.setLayer(.planets)
            spriteComp.node.addChild(background, withName: SpriteComponent.baseKey)
            
            physComp.addBody(SKPhysicsBody(circleOfRadius: radius), withName: PhysicsComponent.mainKey,
                             categoryMask:      Bitmasks.volumeBody,
                             collisionMasks:    [Bitmasks.off],
                             contactMasks:      [Bitmasks.projectile, Bitmasks.starship,
                                                 Bitmasks.volumeBody],
                             fieldMasks:        [Bitmasks.gravField, Bitmasks.dragField])
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // Splits into multiple smaller Meteor() entities
    func wasHit() {}
    
    
    //
    override func didBeginContact(withConformingEntity entity: HandlesEntityContacts) {
        
        if let meteor = entity as? Meteor {
            self.hp -- meteor.hp
            meteor.wasHit()
            self.wasHit()
            
        } else if let starship = entity as? Starship {
            starship.map?.starshipsWereDestroyed(fromTeams: [starship.team])
            self.hp -= 1
            self.wasHit()
        }
        
    }
    
    override func didEndContact(withConformingEntity entity: HandlesEntityContacts) {}
    
    
}

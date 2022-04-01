//
//  ContactDelegate.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 6/5/21.
//

import SpriteKit


// Used by the scene to handle physics contacts
class ContactDelegate: NSObject, SKPhysicsContactDelegate {
    
    // Don't really know what this does. Set it to true in case it is used in some background guard or if
    func responds(to aSelector: Selector!) -> Bool { return true }
    
    
    // Specifies the type of handler method to be called
    enum ContactFuncs {
        case didBegin
        case didEnd
    }
    
    // Informs the entities of specified physics bodies of a contact
    private func runContactHandlers(for contactFunc: ContactFuncs, _ physBodies: [SKPhysicsBody]) {
        
        // Stores the entities which made contact
        // - Will store no more or less than two
        var entities: [GameEntity] = []
        
        
        // Determines the game entities taking part in the collision
        for physicsBody in physBodies {
            if let scene = physicsBody.node?.scene as? UnSGScene {
                
                // Iterates over all physics bodies attached to the entity and
                // checks if one of them is the specified physics body
                for entity in scene.getLowerEntities(ofType: GameEntity.self) as! [GameEntity] {
                    for body in entity.physComp.bodies.values {
                        if body === physicsBody {
                            // Check complete, appends entity to array
                            entities.append(entity)
                        }
                    }
                }
                
            }
        }
        
        // Ensuers that both entities are available to call contact methods on
         guard let entOne = entities.first,
               let entTwo = entities.last
            else { print("ERROR: Not enough entities for collision \(entities)"); return }
        
        
        if physBodies[0].categoryBitMask == physBodies[1].categoryBitMask {
            // Calls appropriate methods for ONE entity to handle contact with the other
            if contactFunc == .didBegin {
                entOne.didBeginContact(withConformingEntity: entTwo)
            } else {
                entOne.didEndContact(withConformingEntity: entTwo)
            }
        } else {
            // Calls appropriate methods of BOTH entities to handle contact with the other
            if contactFunc == .didBegin {
                entOne.didBeginContact(withConformingEntity: entTwo)
                entTwo.didBeginContact(withConformingEntity: entOne)
            } else {
                entOne.didEndContact(withConformingEntity: entTwo)
                entTwo.didEndContact(withConformingEntity: entOne)
            }
        }
        
    }
    
    // Called by didBegin() and didEnd() methods
    private func handleContact(_ contact: SKPhysicsContact, forKeys keys: [UInt32], callableType: ContactFuncs) {
        
        // The physics bodies which contacted
        var bodies: Set<SKPhysicsBody> = [contact.bodyA, contact.bodyB]
        // OR'ed category masks of the bodies used to determine which categories of bodies collided
        let actionKey: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        // Runs contact handler for bodies with matching bitmasks
        for key in keys {
            if actionKey == key {
                runContactHandlers(for: callableType, [bodies.popFirst()!, bodies.popFirst()!])
                return
            }
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        handleContact(contact,
                      forKeys: [Bitmasks.starship   | Bitmasks.projectile,
                                Bitmasks.starship,
                                Bitmasks.starship   | Bitmasks.volumeBody,
                                Bitmasks.projectile | Bitmasks.shield,
                                Bitmasks.projectile | Bitmasks.staticBody,
                                Bitmasks.projectile | Bitmasks.volumeBody,
                                Bitmasks.volumeBody,
                                Bitmasks.edgeBody   | Bitmasks.projectile,
                                Bitmasks.edgeBody   | Bitmasks.starship,
                                Bitmasks.edgeBody   | Bitmasks.volumeBody],
                      callableType: .didBegin)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        handleContact(contact,
                      forKeys: [Bitmasks.starship   | Bitmasks.projectile,
                                Bitmasks.projectile | Bitmasks.shield,
                                Bitmasks.edgeBody   | Bitmasks.projectile,
                                Bitmasks.edgeBody   | Bitmasks.starship,
                                Bitmasks.edgeBody   | Bitmasks.volumeBody],
                      callableType: .didEnd)
    }
    
    
}

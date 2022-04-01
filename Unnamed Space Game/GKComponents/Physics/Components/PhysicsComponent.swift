//
//  PhysicsComponent.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 3/1/21.
//

import GameplayKit
import SpriteKit


//
class PhysicsComponent: GKComponent {
    
    //
    let node = SKNode()
    
    // Physics bodies assigned to the entity
    var bodies: [String: SKPhysicsBody] = [:]
    
    static let mainKey: String = "main"
    var mainBody: SKPhysicsBody? { return bodies[PhysicsComponent.mainKey] ?? nil }
    
    
    //
    func addBody(_ body: SKPhysicsBody, withName name: String) {
        body.isDynamic = true
        bodies[name]   = body
    }
    
    //
    func addBody(_ body: SKPhysicsBody, withName name: String,
                 categoryMask: UInt32,
                 collisionMasks: [UInt32], contactMasks: [UInt32], fieldMasks: [UInt32]) {
        
        body.setBitmasks(category: categoryMask,
                         collision: collisionMasks,
                         contact: contactMasks,
                         field: fieldMasks)
        addBody(body, withName: name)
    }
    
    
}

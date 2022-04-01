//
//  MapBoundary.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 28/5/21.
//

import SpriteKit
import GameplayKit

//
class MapBoundary: GameEntity {
    
    //
    enum Boundary {
        // Standard boundary which causes entities to bounce off.
        // - The associated value is used to determine the damage taken by entities contacting self
        case edge(Int)
        // Teleports to opposite end of the map
        case looped(Pole)
        // Teleports to opposite end of the map and inverts
        case twisted(Pole)
    }
    let boundaryType: Boundary
    
    static let boundaryKey: String = "boundary"
    
    // Used to determine the location to teleport entities to
    private var areaOfEffect: Pole?
    // Used for destructive edges
    var hp: Int = 0
    
    
    init(_ boundaryType: Boundary, path: CGMutablePath,
         lineWidth: CGFloat = 0,
         strokeColour: NSColor = .clear) {
        
        self.boundaryType = boundaryType
        
        super.init()
        
        let shape = SKShapeNode(path: path)
        shape.lineWidth = lineWidth
        shape.strokeColor = strokeColour
        shape.setLayer(.edges)
        spriteComp.node.addChild(shape, withName: MapBoundary.boundaryKey)
        
        physComp.addBody(SKPhysicsBody(edgeLoopFrom: path), withName: PhysicsComponent.mainKey)
        spriteComp.node.physicsBody = physComp.mainBody
        
        switch boundaryType {
        case .edge(let hp):
            physComp.mainBody?.setBitmasks(category:  Bitmasks.edgeBody,
                                           collision: [Bitmasks.projectile, Bitmasks.starship, Bitmasks.volumeBody],
                                           contact:   [Bitmasks.projectile, Bitmasks.starship, Bitmasks.volumeBody],
                                           field:     [Bitmasks.off])
            self.hp = hp
            self.areaOfEffect = nil
            
        case .looped(let aoe):
            physComp.mainBody?.setBitmasks(category:  Bitmasks.edgeBody,
                                           collision: [Bitmasks.off],
                                           contact:   [Bitmasks.projectile, Bitmasks.starship, Bitmasks.volumeBody],
                                           field:     [Bitmasks.off])
            self.hp = 0
            self.areaOfEffect = aoe
        case .twisted(let aoe):
            physComp.mainBody?.setBitmasks(category:  Bitmasks.edgeBody,
                                           collision: [Bitmasks.off],
                                           contact:   [Bitmasks.projectile, Bitmasks.starship, Bitmasks.volumeBody],
                                           field:     [Bitmasks.off])
            self.hp = 0
            self.areaOfEffect = aoe
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // Used for boundaries that have been set to destroy entities on contact
    override func didBeginContact(withConformingEntity entity: HandlesEntityContacts) {
        //
        guard hp > 0
            else { return }
        
        if let starship = entity as? Starship {
            // Destroys starship
            (starship.entity as? Map)?.starshipsWereDestroyed(fromTeams: [starship.team])
            
        } else if let projectile = entity as? Projectile {
            // Subtracts the hp levels of the projectile and removes if hp is 0
            projectile.hp -= hp
            projectile.wasHit()
            
        } else if let meteor = entity as? Meteor  {
            // Splits meteor
            meteor.wasHit()
        }
        
    }
    
    // Teleports entities passing through the area of effect
    override func didEndContact(withConformingEntity entity: HandlesEntityContacts) {
        // Yes, all entities passed will be GameEntities. This is just to allow easy access to their sprite comps
        guard let entity = entity as? GameEntity
            else { return }
        
        // Had to use a switch as if statements don't work on enums with associated values
        // Did not need to catch the .edge case as teleportation only happens if AOE is set
        switch boundaryType {
        case .twisted:
            // If entity is a Starship, inverts controls and falls through to apply teleport actions
            (entity as? Starship)?.isInverted.flip()
            fallthrough
            
        default:
            // So we don't have to deal with non-teleporting boundaries
            /// STC: This guard may have to be extended to only allow entities of certain types to be teleported
            guard let aoe = areaOfEffect
                else { return }
            
            // Gets the accumulated frames of both to determine whether the entity has passed into the AOE
            let frame = spriteComp.base!.calculateAccumulatedFrame()
            let entityFrame = entity.spriteComp.node.calculateAccumulatedFrame()
            
            // Inverts x or y position depending on whether the entity has passed into the AOE
            switch aoe {
            case .north:
                if entityFrame.minY > frame.maxY { entity.spriteComp.node.position.y *= -1 }
                
            case .east:
                if entityFrame.minX > frame.maxX { entity.spriteComp.node.position.x *= -1 }
                
            case .south:
                if entityFrame.maxY < frame.minY { entity.spriteComp.node.position.y *= -1 }
                
            case .west:
                if entityFrame.maxX < frame.minX { entity.spriteComp.node.position.x *= -1 }
            }
            
        }
        
    }
    
    // Does not have functionality in this object
    override var map: Map? { return nil }
    
}

//
//  Projectile.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 9/5/21.
//

import SpriteKit
import GameplayKit


//
class Projectile: GameEntity {
    
    // Multiplied by the a Starship() entity's length to get the radius of self
    static let lowerLengthRatio: CGFloat = 0.1
    static let upperLengthRatio: CGFloat = 0.3
    
    // If friendly fire is disabled, this is used to determine whether the projectile can damage the target
    // - Set to either team to disallow damage to that player
    // - Set to 'nil' if the projectile must damage all players
    var team: Team?
    
    private weak var starship: Starship?
    
    // Doubles as health and power level
    var hp: Int = 1
    
    init(radius: CGFloat, fromStarship starship: Starship) {
        
        self.team = starship.team
        self.starship = starship
        
        super.init()
        
        // Creates a Startpoint wich removes self from parent when the map resets
        self.startpoint = Startpoint(withActions: [SKAction.run { SKAction.removeFromParent() }])
        
        // Creates sprite and sets parent and location
        let base     = SKSpriteNode()
        base.size    = CGSize(squareOfWidth: radius * 2)
        base.texture = SKTexture.projectile(fromTeam: starship.team)
        base.setLayer(.projectiles)
        spriteComp.node.addChild(base, withName: SpriteComponent.baseKey)
        
        spriteComp.node.position.x = starship.origLength / 2
        starship.spriteComp.node.addChild(spriteComp.node)
        
        // Must add to entity tree so that contacts can be handled
        starship.entity?.addEntities([self])
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // Increases the size of the projectile as a visual representation of its' power
    func charge() {
        // Checks that this method is not called on a projectile that has already left its' starship
        guard let team = team
            else { print("ERROR: Cannot charge a Projectile() that has already been fired"); return }
        
        let maxCharge  = Settings.Starships.projectileMaxCharge.get(team).value
        let chargeTime = Settings.Starships.projectileChargeTime.get(team).value
        
        // Creates a sequence of actions where the scale is determined based on the raange iterator
        var scale: [SKAction] = []
        for i in 1...maxCharge {
            let size = SKAction.scale(to: CGFloat(i + 1), duration: chargeTime)
            let hp = SKAction.run { [weak self] in self?.hp = i }
            scale.append(SKAction.sequence([size, hp]))
        }
        
        // Runs actions
        spriteComp.node.run(SKAction.sequence(scale))
    }
    
    // Detatches self from starship and arms
    func fire() {
        // Checks that it is added to a starship
        guard let starship = starship,
              let display  = starship.spriteComp.node.parent
            else { return }
        
        // Stops all actions and resets the parent of the projectile
        spriteComp.node.removeAllActions()
        
        // Precalculates new position and moves sprite to display
        let pos = display.convert(spriteComp.node.position, from: spriteComp.node)
        spriteComp.node.move(toParent: display)
        spriteComp.node.position = pos
        
        // Creates and sets up physics body
        let radius = spriteComp.node.calculateAccumulatedFrame().size.width / 2
        physComp.addBody(SKPhysicsBody(circleOfRadius: radius), withName: PhysicsComponent.mainKey)
        physComp.mainBody?.setProperties(asEntityType: Projectile.self)
        spriteComp.node.physicsBody = physComp.mainBody
        // Applies impulses
        let h = Settings.Physics.projectileImpulse * CGFloat(hp)
        let a = starship.spriteComp.node.zRotation
        physComp.mainBody?.applyImpulse(CGVector(withHypotenuse: h, angle: a))
        
        // Arms self
        self.starship = nil
    }
    
    
    // Removes self if the power level is below 1
    func wasHit() {
        guard hp <= 0
            else { return }
        
        spriteComp.node.removeFromParent()
        removeFromEntity()
    }
    // Removes self regardless
    func destroy() {
        hp = 0
        wasHit()
    }
    
    
    //
    override func didBeginContact(withConformingEntity entity: HandlesEntityContacts) {
        
        if let starship = entity as? Starship {
            // If projectile has not hit a friendly, informs the map entity of the destruction
            guard starship.team != team
                else { return }
            
            map?.starshipsWereDestroyed(fromTeams: [starship.team])
            
            self.hp -= 1
            self.wasHit()
            
        } else if let shield = entity as? Shield {
            // Only damages shield if not on the same side
            guard shield.team != team
                else { return }
            
            self.hp -- shield.hp
            
            self.wasHit()
            shield.wasHit()
            
        } else if let meteor = entity as? Meteor {
            
            self.hp -- meteor.hp
            
            meteor.wasHit()
            self.wasHit()
            
        } else if let _ = entity as? Planet {
            self.destroy()
            
        } else if let projectile = entity as? Projectile {
            // If collisions are allowed, modifies the power levels of the colliding projectiles
            guard Settings.Game.projectilesCollide.value
                else { return }
            
            self.hp -- projectile.hp
            projectile.wasHit()
            self.wasHit()
        }
        
    }
    
    //
    override func didEndContact(withConformingEntity entity: HandlesEntityContacts) {
        
        if let starship = entity as? Starship {
            if starship.team == team && starship.shields.isEmpty && Settings.Game.friendlyFire.value {
                team = nil
            }
            
        } else if let shield = entity as? Shield {
            if shield.team == team && Settings.Game.friendlyFire.value {
                team = nil
            }
            
        }
        
    }
    
    
}

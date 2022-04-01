//
//  Starship.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 14/12/20.
//

import GameplayKit
import SpriteKit


// Use this instead of Ints to differentiate players
enum Team: CaseIterable {
    case one
    case two
    
    // Returns the opposing team
    func other() -> Team {
        let team: Team = (self == .one) ? .two : .one
        return team
    }
    
}

// Object for player entities
class Starship: GameEntity {
    
    //
    let team: Team
    
    //
    enum Action {
        case thrusters(Action.Thrusters)
        case cannon(Action.Cannon)
        case autopilot(Action.Autopilot)
        
        enum Thrusters { case bow, stern, port, starboard }
        enum Autopilot { case linear, angular }
        enum Cannon    { case charge, fire }
    }
    
    
    // Handles key presses sent from scene
    let inputComp   = KeyInputComponent()
    //
    let cockpitLink = CockpitLinkComponent()
    //
    let autopilot   = AutopilotComponent()
    
    // An array of entities, not a component!
    var shields: [Shield] = []
    
    
    // Used to reset the size of the base sprite after
    // any scaling and actions have been carried out
    /// MAY NOT NEED THIS
    let origLength: CGFloat
    //
    private var projectile: Projectile?
    //
    var isInverted: Bool = false
    
    
    init(_ team: Team, length: CGFloat) {
        
        self.team = team
        self.origLength = length
        
        super.init()
        addComponent(inputComp)
        addComponent(autopilot)
        addComponent(cockpitLink)
        
        setShields()
        
        // Adds a starship texture to sprite component
        let background = SKSpriteNode()
        background.texture = SKTexture.starship(forPlayer: team)
        background.size = CGSize(width: length, height: length * 0.75)
        background.setLayer(.ships)
        spriteComp.node.addChild(background, withName: SpriteComponent.baseKey)
        
        
        // Creates and adds a path based physics body
        let physPath = CGMutablePath()
        let points = [CGPoint(x: background.frame.minX, y: background.frame.maxY),
                      CGPoint(x: background.frame.maxX, y: 0),
                      CGPoint(x: background.frame.minX, y: background.frame.minY),
                      CGPoint(x: background.frame.minX + length / 7, y: -background.size.height / 6),
                      CGPoint(x: background.frame.minX + length / 7, y: background.size.height / 6)]
        physPath.addLines(between: points)
        physPath.closeSubpath()
        
        physComp.addBody(SKPhysicsBody(polygonFrom: physPath), withName: PhysicsComponent.mainKey)
        physComp.mainBody?.setProperties(asEntityType: Starship.self)
        spriteComp.node.physicsBody = physComp.mainBody
    }
    
    // Creates and adds shields
    func setShields() {
        
        // Resets shields array
        self.shields = []
        
        // Appends a new array of shields
        let totalSections = Settings.Starships.shieldSections.get(team).value
        if totalSections > 0 {
            for i in 0...totalSections {
                shields.append(Shield(team, shieldSectionNum: i, starshipLength: origLength))
                spriteComp.node.addChild(shields[i].spriteComp.node)
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // Applies impulses to control movement
    func engageThrusters(_ thrusters: Action.Thrusters) {
        
        // Applies angular impulse of specfied strength
        switch thrusters {
        case .bow:
            let vector = CGVector(withHypotenuse: Settings.Physics.fowardThrusterImpulse,
                                  angle: spriteComp.node.zRotation)
            physComp.mainBody?.applyImpulse(vector)
        case .stern:
            let vector = CGVector(withHypotenuse: Settings.Physics.rearThrusterImpulse,
                                  angle: spriteComp.node.zRotation)
            physComp.mainBody?.applyImpulse(vector)
        case .port:
            physComp.mainBody?.applyAngularImpulse(Settings.Physics.angularThrusterImpulse)
        case .starboard:
            physComp.mainBody?.applyAngularImpulse(-Settings.Physics.angularThrusterImpulse)
        }
        
    }
    
    // Creates and charges a projectile
    func chargeProjectile() {
        // Only runs if there is no projectile currently being charged
        guard projectile == nil
            else { return }
        
        // Creates and adds a new projectile
        projectile = Projectile(radius: origLength * Projectile.lowerLengthRatio, fromStarship: self)
        // Calls charge() method to increase projectiles' power
        projectile?.charge()
    }
    
    // Applies impulse to charging projectile and removes reference to projectile
    func fireProjectile() {
        projectile?.fire()
        self.projectile = nil
    }
    
    
    // Creates an emmitter to simulate explosion
    /// TODO: Set up particles emitted by emitter node
    private func runExposion() {
        
        // Removes sprite component from map
        spriteComp.node.removeFromParent()
        
        // Sets up emitter and adds to map
        let shades = SKTexture.Shades.allCases.filter { $0 == SKTexture.Shades.darkest }
        for shade in shades {
            let emitter = SKEmitterNode.starshipExplosion(forTeam: team, shade: shade)
            emitter.position = spriteComp.node.position
            map?.spriteComp.node.addChild(emitter)
            
            // Creates and runs an SKAction to remove the emitter after the explosion
            let action = SKAction.sequence([
                .wait(forDuration: 0.3),
                .removeFromParent()
            ])
            emitter.run(action)
        }
        
    }
    
    //
    func destroy() {
        runExposion()
    }
    
    
    //
    override func didBeginContact(withConformingEntity entity: HandlesEntityContacts) {
        
        if let starship = entity as? Starship {
            map?.starshipsWereDestroyed(fromTeams: [self.team, starship.team])
            
        } else if let planet = entity as? Planet {
            if planet.destroysStarships {
                map?.starshipsWereDestroyed(fromTeams: [team])
            }
        }
        
    }
    
    override func didEndContact(withConformingEntity entity: HandlesEntityContacts) {}
    
    
}

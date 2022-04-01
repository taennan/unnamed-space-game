//
//  Startpoint.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 13/6/21.
//

import SpriteKit
import GameplayKit

// Contains values used to reset a game entity when a map is reset
final class Startpoint: GKComponent {
    
    private let x: CGFloat
    private let y: CGFloat
    
    private let angle: CGFloat
    
    // Stores actions to be replayed after the map has removed all actions
    var actions: [SKAction] = []
    // Physics impulses to be applied on map startup
    var angularImpulse: CGFloat  = 0
    var linearImpulse:  CGVector = CGVector(dx: 0, dy: 0)
    
    init(x: CGFloat, y: CGFloat, angle: CGFloat) {
        //
        guard x < 1 && x > -1 && y < 1 && y > -1
            else { fatalError("Startpoint position x or y MUST be within range -1...1") }
        
        self.x = x
        self.y = y
        self.angle = angle
        
        super.init()
    }
    
    //
    convenience init(withActions actions: [SKAction]) {
        self.init(x: 0, y: 0, angle: 0)
        self.actions = actions
    }
    
    //
    static func opposingPoints(xOne: CGFloat, yOne: CGFloat, angleOne: CGFloat) -> [Startpoint] {
        return [
            Startpoint(x: xOne,  y: yOne,  angle: angleOne),
            Startpoint(x: -xOne, y: -yOne, angle: angleOne + CGFloat.pi)
        ]
    }
    //
    static func mirroredPoints(xOne: CGFloat, yOne: CGFloat, angleOne: CGFloat, mirroredAxis: CGPoint.Axis) -> [Startpoint] {
        
        /// TODO: Rotate the angle of the second Startpoint by appropriate amount
        if mirroredAxis == .y {
            return [
                Startpoint(x: xOne,  y: yOne, angle: angleOne),
                Startpoint(x: -xOne, y: yOne, angle: angleOne)
            ]
        } else {
            return [
                Startpoint(x: xOne, y: yOne,  angle: angleOne),
                Startpoint(x: xOne, y: -yOne, angle: angleOne)
            ]
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    //
    func applyAll() {
        entity?.component(ofType: SpriteComponent.self)?.node.removeAllActions()
        applyPositions()
        applyActions()
        applyPhysics()
    }
    
    //
    func applyPositions() {
        report()
        guard let node   = entity?.component(ofType: SpriteComponent.self)?.node,
              let parent = node.parent
            else { print("ERROR: Appyling startpoint positions failed"); return }
        
        node.zRotation = angle
        node.position  = CGPoint(x: (parent.calculateAccumulatedFrame().width / 2) * x,
                                 y: (parent.calculateAccumulatedFrame().height / 2) * y)
    }
    //
    func applyActions() {
        report()
        guard let node = entity?.component(ofType: SpriteComponent.self)?.node
            else { print("ERROR: Appyling startpoint actions failed"); return }
        
        node.run(SKAction.group(actions))
    }
    //
    func applyPhysics() {
        report()
        guard let physBody = entity?.component(ofType: PhysicsComponent.self)?.mainBody
            else { print("ERROR: Appyling startpoint physics failed"); return }
        
        physBody.applyAngularImpulse(angularImpulse)
        physBody.applyImpulse(linearImpulse)
    }
    
    private func report() {
        print(entity ?? "NO ENTITY")
        print(entity?.component(ofType: PhysicsComponent.self) as Any)
        print(entity?.component(ofType: SpriteComponent.self) as Any)
        print(entity?.component(ofType: PhysicsComponent.self)?.node.parent as Any)
    }
    
}

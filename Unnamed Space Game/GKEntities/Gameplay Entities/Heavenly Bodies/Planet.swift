//
//  Planet.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 29/4/21.
//

import SpriteKit
import GameplayKit

// Used for indestructible rounded static bodies
class Planet: GameEntity {
    
    // Used to add circular atmospheres, gravitational and magnetic fields
    // - Multiple drag fields can be added for atmospheres and oceans
    let fieldComp = FieldComponent()
    
    // Set to true to destroy Starship() entities on contact
    var destroysStarships: Bool = false
    
    init(radius: CGFloat, texture: SKTexture) {
        super.init()
        // Checks if appropriate args have been passed
        guard radius > 0
            else { print("ERROR: Initialised Planet() entity with radius \(radius)"); return }
        
        addComponent(fieldComp)
        spriteComp.node.addChild(fieldComp.node)
        
        let background = SKSpriteNode()
        background.texture = texture
        background.size = CGSize(width: radius, height: radius)
        background.setLayer(.planets)
        spriteComp.node.addChild(background, withName: SpriteComponent.baseKey)
    }
    
    // Creates an action which rotates the sprite by 360 degrees at specified speed
    func setRotation(rotationDuration: TimeInterval) {
        let rotate = SKAction.rotate(byAngle: 2, duration: rotationDuration)
        let action = SKAction.repeatForever(rotate)
        spriteComp.node.run(action)
    }
    
    // These methods create actions which move self along predetermined paths
    
    // Creates an orbit with a custom path
    func setOrbit(customPath path: CGMutablePath, orbitDuration: TimeInterval) {
        let move   = SKAction.follow(path, duration: orbitDuration)
        let action = SKAction.repeatForever(move)
        spriteComp.node.run(action)
    }
    // Calls the above method with a path created from the specified rect
    func setOrbit(ellipseInRect rect: CGRect, orbitDuration: TimeInterval) {
        let path = CGMutablePath()
        path.addEllipse(in: rect)
        setOrbit(customPath: path, orbitDuration: orbitDuration)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
}

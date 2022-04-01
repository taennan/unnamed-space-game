//
//  Display.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 9/12/20.
//

import SpriteKit
import GameplayKit

// Base entity used as a background to add sprites and effects on
class Display: UnSGEntity {
    
    // Used to determine the size and position of background
    let pole: Pole
    
    // You know what this does...
    let spriteComp = SpriteComponent()
    // Used as a key for both the static effect sprite and its' actions
    private static let staticKey: String = "static"
    
    // All sprites are added to this node
    // - It will be overridden to return the crop nodes of subclasses that have cropped views
    var rootNode: SKNode { return spriteComp.node }
    
    // Entities added to self will use this value to determine their size
    // - Is computed as the size of the background changes with window resizing
    var size: CGSize {
        return Display.size(ofPole: pole)
    }
    
    // For easy access to the scene
    weak var scene: UnSGScene? { return spriteComp.node.scene as? UnSGScene }
    
    
    init(_ pole: Pole) {
        
        self.pole = pole
        
        // Creates and adds a background to SpriteComponent
        spriteComp.node.addChild(SKSpriteNode(), withName: SpriteComponent.baseKey)
        spriteComp.base?.texture    = SKTexture.square(.grey, .darkest)
        spriteComp.base?.size       = Display.size(ofPole: pole)
        spriteComp.node.position    = Display.position(ofPole: pole)
        spriteComp.base?.setLayer(.displayLower)
        
        
        /// Uncomment if needed for testing
        /*
        switch pole {
        case .east:  spriteComp.base?.texture = SKTexture.square(.red)
        case .west:  spriteComp.base?.texture = SKTexture.square(.blue)
        case .north: spriteComp.base?.texture = SKTexture.square(.green)
        case .south: spriteComp.base?.texture = SKTexture.square(.yellow)
        }
        */
        
        super.init()
        addComponent(spriteComp)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // Meant to be overridden to do setup
    func didAddToScene() {}
    
    // Creates a fancy ant-war effect for specified duration
    func runStatic(duration: TimeInterval) {
        
        // The sprite which will display the generated static textures
        let staticSprite = SKSpriteNode(texture: nil, color: .clear, size: self.size)
        spriteComp.node.addChild(staticSprite, withName: Display.staticKey)
        
        
        // Cretes noise from perlin source
        // - Test any adjusted settings in the 'SpriteKit Testing' project
        let source = GKPerlinNoiseSource(frequency: 2, octaveCount: 10, persistence: 1.2,
                                         lacunarity: 2, seed: 0)
        let noise = GKNoise(source)
        
        // Must declare these initial map values here as they will be used by the SKAction closures
        let sampleCount = vector_int2(100, 100)
        let size        = vector_double2(5, 5)
        let origin      = vector_double2(100, 0)     // <--- Set high to pass the slipping part
        // The original slice of the perlin noise
        var map = GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: false)
        
        
        // Creates action which moves the noise map along the x-axis and sets
        //  the sprites' texture to match the new slice of the perlin noise
        let wait = SKAction.wait(forDuration: 0.1)
        let move = SKAction.run {
            [weak self] in
            map = GKNoiseMap(noise, size: size, origin: vector2(map.origin.x + 1, 0),
                             sampleCount: sampleCount, seamless: false)
            if let sprite = self?.spriteComp.node.childNode(withName: Display.staticKey) as? SKSpriteNode {
                sprite.texture = SKTexture(noiseMap: map)
            }
        }
        let seq = SKAction.sequence([wait, move])
        let action = SKAction.repeatForever(seq)
        
        
        // Starts action with key and stops after specified duration
        if let sprite = spriteComp.node.childNode(withName: Display.staticKey) as? SKSpriteNode {
            sprite.run(action, withKey: Display.staticKey)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: {
                [weak sprite] in
                sprite?.removeAction(forKey: Display.staticKey)
            })
        }
        
    }
    
    
}

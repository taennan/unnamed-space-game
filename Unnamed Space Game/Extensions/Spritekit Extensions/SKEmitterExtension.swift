//
//  SKEmitterExtension.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 31/7/21.
//

import SpriteKit

//
extension SKEmitterNode {
    
    static func starshipExplosion(forTeam team: Team, shade: SKTexture.Shades) -> SKEmitterNode {
        let colour  = Settings.Starships.colours.get(team).value
        let texture = SKTexture(imageNamed: "\(colour.rawValue)\(shade.rawValue)\(SKTexture.Shapes.circle.rawValue)")
        
        // Sets up emitter
        let emitter = SKEmitterNode()
        //
        emitter.particleBirthRate       = 15
        emitter.particleLifetime        = 0.7
        emitter.particleLifetimeRange   = 0.2
        //
        emitter.particleSpeed           = 4
        emitter.particleSpeedRange      = 0.3
        //
        emitter.emissionAngleRange      = 2
        //
        emitter.particleScaleRange      = 0.3
        emitter.particleScaleSpeed      = 0.5
        //
        emitter.particleTexture         = texture
        emitter.particleColorAlphaRange = 0.2
        emitter.particleAlphaSpeed      = 0.7
        //
        emitter.particleZPosition       = UnSGScene.Layers.effects.rawValue
        
        return emitter
    }
    
}

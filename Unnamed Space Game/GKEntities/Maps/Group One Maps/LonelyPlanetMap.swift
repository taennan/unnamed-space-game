//
//  LonelyPlanetMap.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 21/7/21.
//

import SpriteKit

//
class LonelyPlanetMap: Map {
    
    override class var name: String { return "Lonely Planet" }
    
    let planet: Planet
    
    required init() {
        
        let size = Display.size(ofPole: .west)
        let planetRadius = size.width * 0.1
        let atmRadius    = planetRadius * 2
        let gravRadius   = planetRadius * 3
        
        self.planet = Planet(radius: planetRadius, texture: SKTexture.circle(.olive, .none))
        planet.fieldComp.addField(.gravity,
                                  radius: gravRadius,
                                  strength: 10,
                                  falloff: 0,
                                  hasSpriteWithCustomTexture: (false, nil))
        planet.fieldComp.addField(.drag,
                                  radius: atmRadius,
                                  strength: 5,
                                  falloff: 0,
                                  hasSpriteWithCustomTexture: (true, SKTexture.circle(.teal, .light)))
        
        super.init(starshipScale: Map.Scale.medium.rawValue,
                   startpoints: Startpoint.opposingPoints(xOne: -0.8, yOne: 0, angleOne: 0))
        setBoundary(MapBoundaryComponent.euclidian(rect: spriteComp.base!.frame))
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
}

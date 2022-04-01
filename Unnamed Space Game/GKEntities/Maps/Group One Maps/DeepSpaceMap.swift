//
//  DeepSpaceMap.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 8/6/21.
//

import SpriteKit

//
class DeepSpaceMap: Map {
    
    override class var name: String { return "Deep Space" }
    
    required init() {
        super.init(starshipScale: Map.Scale.medium.rawValue,
                   startpoints: Startpoint.opposingPoints(xOne: -0.8, yOne: 0, angleOne: 0))
        setBoundary(MapBoundaryComponent.euclidian(rect: spriteComp.base!.frame))
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
}

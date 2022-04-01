//
//  CockpitMeter.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 26/7/21.
//

import SpriteKit
import GameplayKit

//
class CockpitMeter: UnSGEntity {
    
    // You know what these do
    let team: Team
    let spriteComp = SpriteComponent()
    
    init(forTeam team: Team) {
        self.team = team
        super.init()
        addComponent(spriteComp)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //
    func updateInfo(forStarship starship: Starship) {
        guard starship.team == team
            else { fatalError("Tried to update CockpiMeter with info from enemy Starship") }
    }
    
    
}

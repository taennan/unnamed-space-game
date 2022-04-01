//
//  CockpitLinkComponent.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 28/7/21.
//

import GameplayKit

//
final class CockpitLinkComponent: GKComponent {
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private var totalTime: TimeInterval = 0
    
    override func update(deltaTime seconds: TimeInterval) {
        //
        guard let starship = entity as? Starship,
              let cockpit  = starship.map?.gamescene?.cockpit(starship.team)
            else { return }
        
        let execTime = Settings.Starships.cockpitUpdateTime.get(starship.team).value
        guard totalTime > execTime
            else { return }
        
        totalTime = 0
        for meter in cockpit.allMeters {
            meter.update(deltaTime: seconds)
        }
        
    }
    
    
}

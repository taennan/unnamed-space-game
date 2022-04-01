//
//  CockpitDisplay.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 1/5/21.
//

import SpriteKit
import GameplayKit


//
class CockpitDisplay: GameDisplay {
    
    /// MAY NOT NEED THIS
    private let team: Team
    
    // Instruments
    // All these are fairly self explanatory
    let fieldMeter:    FieldMeter
    let shieldMeter:   ShieldMeter
    let velocityMeter: VelocityMeter
    let cannonMeter:   CannonMeter
    let pilotMeter:    PilotMeter
    
    // For quickly iterating over the meters
    let allMeters: [CockpitMeter]
    
    init(forTeam team: Team) {
        
        self.team = team
        
        self.fieldMeter     = FieldMeter(forTeam: team)
        self.shieldMeter    = ShieldMeter(forTeam: team)
        self.velocityMeter  = VelocityMeter(forTeam: team)
        self.cannonMeter    = CannonMeter(forTeam: team)
        self.pilotMeter     = PilotMeter(forTeam: team)
        
        self.allMeters = [fieldMeter, shieldMeter, velocityMeter, cannonMeter, pilotMeter]
        
        if team == .one {
            super.init(.north)
        } else {
            super.init(.south)
        }
        
        addEntities(allMeters)
        for meter in allMeters { spriteComp.node.addChild(meter.spriteComp.node) }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    /*
    private var totalTime: TimeInterval = 0
    
    override func update(deltaTime: TimeInterval) {
        
        let execTime = Settings.starships.cockpitUpdateTime.get(team).value
        guard totalTime > execTime
            else { return }
        
        totalTime = 0
        for meter in allMeters {
            meter.update(deltaTime: deltaTime)
        }
        
    }
    */
    
}

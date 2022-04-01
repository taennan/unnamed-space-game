//
//  User Input.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 14/12/20.
//

import GameplayKit
import SpriteKit


// Handles key events passed from scene to Starship() entities
class KeyInputComponent: GKComponent {
    
    func addEvent(_ event: NSEvent) { activeEvents[event.keyCode] = event }
    
    //
    private var activeEvents: [UInt16: NSEvent] = [:]
    //
    private var totalFrames: Int = 0
    private let frameCap:    Int = 10_000
    private let execFrame:   Int = 10
    
    //
    override func update(deltaTime seconds: TimeInterval) {
        totalFrames += 1
        if totalFrames > frameCap { totalFrames = 0 }
        
        if let starship = entity as? Starship,
               totalFrames % execFrame <= 1 {
            
            //
            defer { activeEvents = [:] }
            
            //
            for (key, event) in activeEvents {
                
                // Key down actions
                if event.type == .keyDown {
                    
                    if starship.team == .one {      // Team one
                        switch key {
                        // Thrusters
                        case KeyCodes.a:        starship.engageThrusters(.port)
                        case KeyCodes.d:        starship.engageThrusters(.starboard)
                        case KeyCodes.w:        starship.engageThrusters(.bow)
                        case KeyCodes.s:        starship.engageThrusters(.stern)
                        // Autopilot
                        case KeyCodes.q:        starship.autopilot.engage(withDirective: .angular)
                        case KeyCodes.e:        starship.autopilot.engage(withDirective: .linear)
                        // Cannon
                        case KeyCodes.spacebar: starship.chargeProjectile()
                            
                        default: continue
                        }
                        
                    } else {                        // Team two
                        switch key {
                        // Thrusters
                        case KeyCodes.left:     starship.engageThrusters(.port)
                        case KeyCodes.right:    starship.engageThrusters(.starboard)
                        case KeyCodes.up:       starship.engageThrusters(.bow)
                        case KeyCodes.down:     starship.engageThrusters(.stern)
                        // Autopilot
                        case KeyCodes.num0:     starship.autopilot.engage(withDirective: .angular)
                        case KeyCodes.numDot:   starship.autopilot.engage(withDirective: .linear)
                        // Cannon
                        case KeyCodes.numEnter: starship.chargeProjectile()
                            
                        default: continue
                        }
                        
                    }
                
                // Key up actions
                } else if event.type == .keyUp {
                    //
                    switch (starship.team, key) {
                    case (.one, KeyCodes.spacebar): starship.fireProjectile()
                    case (.two, KeyCodes.numEnter): starship.fireProjectile()
                        
                    default: return
                    }
                    
                }
            }
        }
        
    }
    
}

//
//  Autopilot.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 17/7/21.
//

import GameplayKit

//
class AutopilotComponent: GKComponent {
    
    enum Directive {
        case linear
        case angular
    }

    
    // TODO
    func engage(withDirective directive: Directive) {
        //
        guard let starship = entity as? Starship
            else { return }
        
        switch directive {
        case .linear:
            starship.physComp.mainBody?.velocity = CGVector(dx: 0, dy: 0)
        case .angular:
            starship.physComp.mainBody?.angularVelocity = 0
        }
    }
    
}

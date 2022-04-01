//
//  CommandComponent.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 6/2/21.
//

import GameplayKit


//
typealias Command = (() -> Void)

//
class CommandComponent: GKComponent {
    
    var command: Command?
    
    // Any commands to be executed when an entity is interacted with will be put here
    func runCommand() {
        if let comm = self.command {
            comm()
        } else {
            print("No command to be run by CommandComponent() object")
        }
    }
    
    
}

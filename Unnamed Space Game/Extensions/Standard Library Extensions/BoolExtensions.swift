//
//  BoolExtensions.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 29/5/21.
//

// No modules yet...

extension Bool {
    
    //
    mutating func flip() {
        if self {
            self = false
        } else {
            self = true
        }
    }
    
}

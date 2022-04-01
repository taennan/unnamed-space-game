//
//  IntExtensions.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 25/6/21.
//

infix operator --

//
extension Int {
    
    // Subtracts the values of both with each other
    static func -- (l: inout Int, r: inout Int) {
        let (newL, newR) = (l - r, r - l)
        l = newL
        r = newR
    }
    
}

//
//  Angle.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 12/6/21.
//

import SpriteKit

//
struct Angle {
    
    // Always in radians
    var value: CGFloat
    
    // Inits value in radians
    init(rad: CGFloat) { self.value = CGFloat.pi * rad }
    init(deg: CGFloat) { self.init(rad: deg / 180) }
    init(rev: CGFloat) { self.init(rad: rev * 2) }
    
    // Custom operators
    
    // Arithmetic
    // Addition
    static func + (l: CGFloat, r: Angle) -> CGFloat { return l + r.value }
    static func + (l: Angle, r: CGFloat) -> CGFloat { return r + l }
    static func + (l: Angle, r: Angle) -> CGFloat { return l.value + r.value }
    
    // Subtraction
    static func - (l: CGFloat, r: Angle) -> CGFloat { return l - r.value }
    static func - (l: Angle, r: CGFloat) -> CGFloat { return r - l }
    static func - (l: Angle, r: Angle) -> CGFloat { return l.value - r.value }
    
    // Multiplication
    static func * (l: CGFloat, r: Angle) -> CGFloat { return l * r.value }
    static func * (l: Angle, r: CGFloat) -> CGFloat { return r * l }
    static func * (l: Angle, r: Angle) -> CGFloat { return l.value * r.value }
    
    // Division
    static func / (l: CGFloat, r: Angle) -> CGFloat { return l / r.value }
    static func / (l: Angle, r: CGFloat) -> CGFloat { return r / l }
    static func / (l: Angle, r: Angle) -> CGFloat { return l.value / r.value }
    
    // Inversion
    static prefix func - (angle: Angle) -> CGFloat {
        let rad = angle.value * -1
        return rad
    }
    
    
    // Equality
    static func == (l: CGFloat, r: Angle) -> Bool { return l == r.value }
    static func == (l: Angle, r: CGFloat) -> Bool { return r == l.value }
    static func == (l: Angle, r: Angle) -> Bool { return l.value == r.value }
    // Inequality
    static func != (l: CGFloat, r: Angle) -> Bool { return l != r.value }
    static func != (l: Angle, r: CGFloat) -> Bool { return r != l.value }
    static func != (l: Angle, r: Angle) -> Bool { return l.value != r.value }
    
    
    // Assignment
    // Addition
    static func += (l: inout Angle, r: CGFloat) { l.value += r }
    static func += (l: inout CGFloat, r: Angle) { l += r.value }
    static func += (l: inout Angle, r: Angle) { l.value += r.value }
    
    // Subtraction
    static func -= (l: inout Angle, r: CGFloat) { l.value -= r }
    static func -= (l: inout CGFloat, r: Angle) { l -= r.value }
    static func -= (l: inout Angle, r: Angle) { l.value -= r.value }
    
    // Multiplication
    static func *= (l: inout Angle, r: CGFloat) { l.value *= r }
    static func *= (l: inout CGFloat, r: Angle) { l *= r.value }
    static func *= (l: inout Angle, r: Angle) { l.value *= r.value }
    
    // Division
    static func /= (l: inout Angle, r: CGFloat) { l.value /= r }
    static func /= (l: inout CGFloat, r: Angle) { l /= r.value }
    static func /= (l: inout Angle, r: Angle) { l.value /= r.value }
    
    
}

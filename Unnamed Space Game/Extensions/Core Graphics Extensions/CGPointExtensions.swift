//
//  CGPointExtensions.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 24/6/21.
//

import SpriteKit

//
extension CGPoint {
    
    // See the Startpoint structure for use cases
    enum Axis {
        case x
        case y
    }
    
    static prefix func + (point: CGPoint) -> CGPoint  { return CGPoint(x: abs(point.x), y: abs(point.y)) }
    static func + (l: CGPoint, r: CGPoint) -> CGPoint { return CGPoint(x: l.x + r.x, y: l.y + r.y) }
    static func += (l: inout CGPoint, r: CGPoint)     { l = l + r }
    
    static func - (l: CGPoint, r: CGPoint) -> CGPoint { return CGPoint(x: l.x - r.x, y: l.y - r.y) }
    static func -= (l: inout CGPoint, r: CGPoint)     { l = l - r }
    
    
}

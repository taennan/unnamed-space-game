//
//  CGRectExtensions.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 9/8/21.
//

import SpriteKit

extension CGRect {
    
    //
    enum Sector {
        case center
        
        case top
        case bottom
        case left
        case right
        
        case topleft
        case bottomleft
        case topright
        case bottomright
    }
    
    //
    func getPosition(ofSector sector: Sector) -> CGPoint {
        switch sector {
        case .center:       return CGPoint(x: midX, y: midY)
        case .top:          return CGPoint(x: midX, y: maxY)
        case .bottom:       return CGPoint(x: midX, y: minY)
        case .left:         return CGPoint(x: minX, y: midY)
        case .right:        return CGPoint(x: maxY, y: midY)
        case .topleft:      return CGPoint(x: minX, y: maxY)
        case .bottomleft:   return CGPoint(x: minX, y: minY)
        case .topright:     return CGPoint(x: maxX, y: maxY)
        case .bottomright:  return CGPoint(x: maxX, y: minY)
        }
    }
    
}

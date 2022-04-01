//
//  CGVectorExtensions.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 12/6/21.
//

import SpriteKit

//
extension CGVector {
    
    init(withHypotenuse h: CGFloat, angle: CGFloat) {
        
        let o = sinf(Float(angle)) * Float(h)
        let a = cosf(Float(angle)) * Float(h)
        
        self.init(dx: CGFloat(a), dy: CGFloat(o))
    }
    
    
}

//
//  CropDisplay.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 31/5/21.
//

import SpriteKit


//
class CropDisplay: Display {
    
    let cropComp = CropComponent()
    //
    override var rootNode: SKNode { return cropComp.cropNode }
    
    override init(_ pole: Pole) {
        super.init(pole)
        addComponent(cropComp)
        spriteComp.node.addChild(cropComp.cropNode)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
}

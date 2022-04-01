//
//  ExtrasMenuDisplay.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 20/5/21.
//

import SpriteKit

//
class ExtrasMenuDisplay: Display {
    
    private let rad: MenuRadioButton
    
    init() {
        
        let p = Pole.south
        
        self.rad = MenuRadioButton(["TESTING", "CREDITS"], displaySize: Display.size(ofPole: p))
        super.init(p)
        
        rad.setButtonCommands([
            { [weak self] in self?.scene?.setDisplays([  ]) },
            { [weak self] in self?.scene?.setDisplays([  ]) }
            ])
        rad.setCurrentButton(0)
        spriteComp.node.addChild(rad.spriteComp.node)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
}

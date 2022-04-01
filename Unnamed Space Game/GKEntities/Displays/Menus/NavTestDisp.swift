//
//  NavTestDisp.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 1/6/21.
//

import SpriteKit

//
class NavTestDisp: Display {
    
    private let btn: Button
    
    init() {
        
        let p = Pole.north
        let size = Display.size(ofPole: p)
        let buttonSize = CGSize(width: size.width * 0.5, height: size.height * 0.2)
        
        self.btn = Button(size: buttonSize)
        btn.setLabel("RETURN", constraint: .height(buttonSize.height * 0.7))
        
        super.init(p)
        
        btn.setCommand({ [weak self] in self?.scene?.view?.presentScene( MenuScene() ) })
        spriteComp.node.addChild(btn.spriteComp.node)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
}

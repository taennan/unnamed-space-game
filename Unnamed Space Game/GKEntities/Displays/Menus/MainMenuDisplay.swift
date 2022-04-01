//
//  MainMenuDisplay.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 1/5/21.
//

import SpriteKit
import GameplayKit

//
class MainMenuDisplay: Display {
    
    private let rad: MenuRadioButton

    init() {
        
        let p = Pole.north
        
        self.rad = MenuRadioButton(["GAME", "SETTINGS", "EXTRAS"], displaySize: Display.size(ofPole: p))
        super.init(p)
        
        rad.setButtonCommands([
            { [weak self] in self?.scene?.setDisplays([ GameMenuDisplay(), Display(.west) ]) },
            { [weak self] in self?.scene?.setDisplays([ SettingsMenuDisplay(), RuleSettingsDisplay() ]) },
            { [weak self] in self?.scene?.setDisplays([ ExtrasMenuDisplay(), Display(.west) ]) }
            ])
        rad.setCurrentButton(0)
        spriteComp.node.addChild(rad.spriteComp.node)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
}

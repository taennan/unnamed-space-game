//
//  ScoreDisplay.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 12/6/21.
//

import SpriteKit
import GameplayKit

//
class ScoreDisplay: GameDisplay {
    
    private let pauseBtn: Button
    private let infoBtn: Button
    
    private let scoreboard: Scoreboard
    
    init() {
        
        let size = Display.size(ofPole: .east)
        let buttonSize = CGSize(squareOfWidth: size.height * 0.6)
        
        self.pauseBtn = Button(size: buttonSize, borderWidth: 0)
        pauseBtn.multiplePressesEnabled = true
        pauseBtn.spriteComp.node.position.x = size.width * -0.4
        
        
        self.infoBtn = Button(size: buttonSize, borderWidth: 0)
        infoBtn.multiplePressesEnabled = true
        infoBtn.setLabel("i", constraint: .height(buttonSize.height * 0.6))
        infoBtn.setCommand({ print("SHOW INFO") })
        infoBtn.spriteComp.node.position.x = -pauseBtn.spriteComp.node.position.x
        
        
        let spacing = size.width * 0.15
        let scoreboardSize = CGSize(width: size.width - ((buttonSize.width + spacing) * 2),
                                    height: buttonSize.height)
        
        self.scoreboard = Scoreboard(size: scoreboardSize)
        
        super.init(.east)
        // Adds entities and sprites
        spriteComp.node.addChild(pauseBtn.spriteComp.node)
        spriteComp.node.addChild(infoBtn.spriteComp.node)
        spriteComp.node.addChild(scoreboard.spriteComp.node)
        
        addEntities([pauseBtn, infoBtn, scoreboard])
        
        //
        let playTexture  = SKTexture.customImage(.playLabel)
        let pauseTexture = SKTexture.customImage(.pauseLabel)
        
        let icon = SKSpriteNode(texture: pauseTexture, size: buttonSize)
        icon.setLayer(.iconInfo)
        pauseBtn.spriteComp.node.addChild(icon, withName: Button.iconKey)
        
        //
        var pause = true
        pauseBtn.setCommand({
            [weak self] in
            if pause {
                self?.pauseBtn.spriteComp.icon?.texture = playTexture
                print("PLAY")
            } else {
                self?.pauseBtn.spriteComp.icon?.texture = pauseTexture
                print("PAUSE")
            }
            pause.flip()
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
}

//
//  StartupScene.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 12/3/21.
//

import SpriteKit


// Displays logos and title
// - This scene does not make use of displays.
// - It is used to cheaply circumvent to the display height resizing problem
class StartupScene: SKScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.size = view.frame.size
        self.backgroundColor = UnSGScene.backgroundColour
        
        /// JUST A PATCH JOB, REMOVE THIS LATER
        let wait = SKAction.wait(forDuration: 0.5)
        let pres = SKAction.run {
            view.presentScene(MenuScene())
        }
        let seq = SKAction.sequence([wait, pres])
        run(seq)
        
        /// Uncomment when needed for testing
        /*
        // First set of logos
        let orgTitle = SKLabelNode(text: "Nassman Werks",
                                   fontColour: .white, fontSize: 10)
        let subTitle = SKLabelNode(text: "presents",
                                   fontColour: orgTitle.fontColor!, fontSize: orgTitle.fontSize)
        subTitle.position.y = orgTitle.frame.minY - subTitle.frame.height
        
        // Second set of logos
        let gameTitle = SKLabelNode(text: appDelegate.projectName,
                                    fontColour: orgTitle.fontColor!, fontSize: orgTitle.fontSize)
        
        
        // Base actions
        let setAlpha = SKAction.fadeOut(withDuration: 0)
        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        let wait = SKAction.wait(forDuration: 0.2)
        // Fades a node in and out of view
        let fadeLogo = SKAction.sequence([setAlpha, fadeIn, wait, fadeIn.reversed(), wait])
        
        let presentFirstLogos = SKAction.run {
            orgTitle.run(fadeLogo)
            subTitle.run(fadeLogo)
        }
        let presentSecondLogos = SKAction.run {
            gameTitle.run(fadeLogo)
        }
        let setScene = SKAction.run {
            [weak self] in
            self?.view?.presentScene(MenuScene())
        }
        
        let runAllLogos = SKAction.sequence([presentFirstLogos, presentSecondLogos, setScene])
        self.run(runAllLogos)
        */
    }
    
    
}

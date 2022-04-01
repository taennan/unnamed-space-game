//
//  ScoreboardEntity.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 30/6/21.
//

import SpriteKit

//
class Scoreboard: GameEntity {
    
    private var labels: Pair<SKLabelNode>
    private let colon:  SKLabelNode
    
    init(size: CGSize) {
        
        let scoreLabelHeight = SKLabelNode.SizeConstraint.height(size.height * 0.8)
        let colonLabelHeight = SKLabelNode.SizeConstraint.height(size.height * 0.6)
        
        // The background
        let base = SKSpriteNode(texture: SKTexture.square(.grey, .dark), color: .clear, size: size)
        base.setLayer(.iconBase)
        
        // The score labels
        self.labels = Pair(SKLabelNode("0", constraint: scoreLabelHeight),
                           SKLabelNode("0", constraint: scoreLabelHeight))
        for team in Team.allCases {
            labels.forElement(team, modWith: {
                $0.fontColor = Colours.getColour(forTeam: team)
                $0.position  = CGPoint(x: size.width * -0.3, y: -size.height / 2)
                $0.setLayer(.iconInfo)
            })
        }
        labels.two.position.x *= -1
        
        // An extra label to use as a divider
        self.colon = SKLabelNode(":", fontColour: Colours.grey, constraint: colonLabelHeight)
        colon.setLayer(.iconInfo)
        
        super.init()
        print(labels.one === labels.two)
        // Adds nodes
        spriteComp.node.addChild(base, withName: SpriteComponent.baseKey)
        spriteComp.node.addChildren([labels.one, labels.two, colon])
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //
    func incrementScore(forTeam team: Team) {
        labels.forElement(team, modWith: {
            let text     = $0.text!
            let newScore = 1 + Int(text)!
            $0.text = String(newScore)
        })
    }
    
    
}

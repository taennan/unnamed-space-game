//
//  Shield.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 9/5/21.
//

import SpriteKit
import GameplayKit


//
class Shield: GameEntity {
    
    // The angle between the edges of each shield section
    static let shieldSpacerAngle: CGFloat = CGFloat.pi / 16
    // Values to multiply length of starship with to calculate uniform sizes for shields
    static let shieldRadiusRatio: CGFloat = 1.2
    static let shieldWidthRatio:  CGFloat = 0.02
    
    let team: Team
    var hp: Int
    
    init(_ team: Team, shieldSectionNum: Int, starshipLength: CGFloat) {
        
        self.team   = team
        self.hp     = Settings.Starships.shieldHP.get(team).value
        
        super.init()
        
        // Checks if the Settings allow starships to be protected by shields
        // - Converted these to CGFloats as they were commonly used in calculations with other CGFloats
        let totalSections = CGFloat(Settings.Starships.shieldSections.get(team).value)
        let sectionNum    = CGFloat(shieldSectionNum)
        guard totalSections > 0 && hp > 0
            else { return }
        
        // Calculates angles to add arc between
        // - The end angle is calculated first as it is used to calculate the offset (if any) of the start angle
        let startAngle: CGFloat
        let endAngle:   CGFloat
        if Settings.Starships.shieldsAreOffset.get(team).value {     // With offset
            endAngle    = ((CGFloat.pi / totalSections) * sectionNum) * 1.5
            startAngle  = ((CGFloat.pi * 2) / totalSections) * sectionNum + endAngle / 2
        } else {                                                        // Without offset
            endAngle    = (CGFloat.pi / totalSections) * sectionNum
            startAngle  = ((CGFloat.pi * 2) / totalSections) * sectionNum
        }
        
        // Creates a path extending in an arc from the starting angle to the end angle
        let path = CGMutablePath()
        path.addArc(center:     CGPoint(x: 0, y: 0),
                    radius:     starshipLength * Shield.shieldRadiusRatio,
                    startAngle: startAngle + Shield.shieldSpacerAngle / 2,
                    endAngle:   endAngle - Shield.shieldSpacerAngle / 2,
                    clockwise:  true)
        
        // Creates a shape node from the path
        let curve           = SKShapeNode(path: path)
        curve.lineWidth     = starshipLength * Shield.shieldWidthRatio
        curve.strokeColor   = NSColor(calibratedRed: 0, green: 0, blue: 1, alpha: 1)  /// <--- Colour is STC
        curve.setLayer(.shields)
        spriteComp.node.addChild(curve)
        // Creates a physics body for the shape node from the path
        physComp.addBody(SKPhysicsBody(edgeChainFrom: path), withName: "shield\(shieldSectionNum)",
                         categoryMask:      Bitmasks.shield,
                         collisionMasks:    [Bitmasks.projectile],
                         contactMasks:      [Bitmasks.off],
                         fieldMasks:        [Bitmasks.off])
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    //
    func wasHit() {}
    
    
    //
    override func didBeginContact(withConformingEntity entity: HandlesEntityContacts) {}
    override func didEndContact(withConformingEntity entity: HandlesEntityContacts) {}
    
    
}

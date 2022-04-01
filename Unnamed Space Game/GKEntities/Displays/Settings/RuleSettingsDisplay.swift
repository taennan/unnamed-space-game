//
//  GameRulesSettingsDisplay.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 18/5/21.
//

import SpriteKit
import GameplayKit

// Contains UI elements used to change the game settings
class RuleSettingsDisplay: Display {
    
    private let ffRad: RadioButton      // Friendly fire radio button
    private let pcRad: RadioButton      // Projectiles collide radio button
    private let mxSel: Selector         // Max points selector
    private let gmRad: RadioButton      // Game mode radio button
    private let mapDrop: DropdownMenu   // Map dropdown menu

    init() {
        
        // Sets whether projectiles destroy starships they were fired from
        self.ffRad = RadioButton(totalButtons: Settings.Game.friendlyFire.elements.count,
                                 buttonSize: SettingsDisplayConstraints.buttonSize, backgroundTexture: nil)
        ffRad.setButtonLabels(["ON", "OFF"], constraint: SettingsDisplayConstraints.labelConstraint)
        ffRad.setButtonCommands(Settings.Game.friendlyFire.elements.map {
            option in {
                Settings.Game.friendlyFire.setIndex(toOption: option)
                print("FRIENDLY FIRE set to: \(Settings.Game.friendlyFire.value)")
            }
        })
        
        
        // Sets whether projectiles destroy each other on contact
        self.pcRad = RadioButton(totalButtons: Settings.Game.projectilesCollide.elements.count,
                                 buttonSize:  SettingsDisplayConstraints.buttonSize, backgroundTexture: nil)
        pcRad.setButtonLabels(["ON", "OFF"], constraint: SettingsDisplayConstraints.labelConstraint)
        pcRad.setButtonCommands(Settings.Game.projectilesCollide.elements.map {
            option in {
                Settings.Game.projectilesCollide.setIndex(toOption: option)
                print("PROJECTILES COLLIDE set to: \(option)")
            }
        })
        
        
        // Sets the maximum rounds or points needed to end the game
        self.mxSel = Selector(displaySize: SettingsDisplayConstraints.buttonSize, backgroundTexture: SKTexture())
        mxSel.setOptionLabels(Settings.Game.maxPoints.elements.map { String($0) },
                              constraint: SettingsDisplayConstraints.labelConstraint)
        mxSel.setCommands(Settings.Game.maxPoints.elements.map {
            arg in {
                Settings.Game.maxPoints.setIndex(toOption: arg)
                print("MAX POINTS set to: \(arg)")
            }
        })
        mxSel.setSelectorLabels(.plusminus, constraint: SettingsDisplayConstraints.labelConstraint)
        
        
        // Sets the game mode
        self.gmRad = RadioButton(totalButtons: Settings.Game.gameMode.elements.count,
                                 buttonSize: SettingsDisplayConstraints.buttonSize, backgroundTexture: nil)
        gmRad.setButtonLabels(Settings.Game.gameMode.elements.map { $0.rawValue },
                              constraint: SettingsDisplayConstraints.labelConstraint)
        gmRad.setButtonCommands(Settings.Game.gameMode.elements.map {
            arg in {
                Settings.Game.gameMode.setIndex(toOption: arg)
                print("GAME MODE set to \(arg)")
            }
        })
        
        
        // Sets the map to be played in
        self.mapDrop = DropdownMenu(totalButtons: Settings.Game.allMaps.count,
                                    buttonsDisplayable: 5, buttonSize: SettingsDisplayConstraints.buttonSize,
                                    dropsDown: false, backgroundTexture: nil)
        mapDrop.setButtonLabels(Settings.Game.allMaps.map { $0.name },
                                constraint: SettingsDisplayConstraints.labelConstraint, position: CGPoint(x: 0, y: 0))
        mapDrop.setDropdownLabel(.arrow, constraint: SettingsDisplayConstraints.labelConstraint)
        mapDrop.setButtonCommands(Settings.Game.allMaps.map {
            arg in {
                Settings.Game.setMap(to: arg)
                print("MAP set to: \(arg)")
            }
        })
        mapDrop.setCurrentButton(0)
        
        
        super.init(.west)
        
        // Adds interactives and labels
        // NOTE: The order of the elements in these arrays are important! Don't change them!
        let interactives = [ffRad, pcRad, mxSel, gmRad, mapDrop]
        let text         = ["FRIENDLY FIRE", "PROJECTILES COLLIDE", "MAX POINTS", "GAME MODE", "MAP"]
        let yPosMults: [CGFloat] = [0.4, 0.2, 0.0, -0.2, -0.4]
        
        for (i, (inter, str)) in zip(interactives, text).enumerated() {
            guard let node = inter.component(ofType: SpriteComponent.self)?.node
                else { fatalError("Tried to add an entity which doesn't have a sprite component") }
            
            // Sets position of and adds interactive
            let interPos = CGPoint(x: SettingsDisplayConstraints.xOffset,
                                   y: Display.size(ofPole: .west).height * yPosMults[i])
            node.setAccFramePosition(anchorPoint: .left, position: interPos)
            addEntities([inter])
            spriteComp.node.addChild(node)
            
            // Creates label from text then adds to self
            let label = SKLabelNode(str, constraint: SettingsDisplayConstraints.labelConstraint)
            label.horizontalAlignmentMode = .left
            label.position                = CGPoint(x: SettingsDisplayConstraints.xOffset,
                                                    y: node.position.y +
                                                       SettingsDisplayConstraints.labelSpacing)
            label.setLayer(.iconInfo)
            spriteComp.node.addChild(label)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
}

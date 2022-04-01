//
//  StarshipSettingsDisplay.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 18/5/21.
//

import SpriteKit
import GameplayKit

// A scrollable display used to set the starship settings
class StarshipSettingsDisplay: Display {///ScrollDisplay {
    
    private let epRad:  RadioButton             // Equalise Players
    
    private var colSel: Pair<Selector>          // Player Colours
    
    private var ssSel:  Pair<Selector>          // Shield Sections
    private var shpRad: Pair<RadioButton>       // Shield HP
    private var soRad:  Pair<RadioButton>       // Shield Offset
    
    private var ccSel:  Pair<Selector>          // Cannon Capacity
    private var crSel:  Pair<Selector>          // Cannon Recharge
    
    private var pctSel: Pair<Selector>          // Projectile Charge Time
    private var pmcRad: Pair<RadioButton>       // Projectile Max Charge
    
    private var fcSel:  Pair<Selector>          // Fuel Capacity
    private var frtSel: Pair<Selector>          // Fuel Recharge Time
    
    
    // Used to iterate over all the above to add to self or create labels from
    private let allInters:  [Any]
    private let twoStaters: [Any]
    private let labelText:  [String] = ["EQUALISE PLAYERS",
                                        "TEAM COLOURS",
                                        "SHIELD SECTIONS", "SHEILD HP", "OFFSET SHIELDS",
                                        "CANNON CAPACITY", "CANNON RECHARGE",
                                        "PROJECTILE MAX CHARGE", "PROJECTILE CHARGE TIME",
                                        "FUEL CAPACITY", "FUEL CHARGE TIME"]
    
    // Used by setColourSelectors() method to create labels for the interactives
    private let colSelLabelConst:    SKLabelNode.SizeConstraint
    private let colSelSelectorConst: SKLabelNode.SizeConstraint
    
    init() {
        
        // Declared button size here as typing in 'SettingsDisplayConstraints.buttonSize' is just ridiculus
        let buttonSize: CGSize = SettingsDisplayConstraints.buttonSize
        
        self.colSelLabelConst    = SettingsDisplayConstraints.labelConstraint
        self.colSelSelectorConst = SettingsDisplayConstraints.labelConstraint
        
        // Inits the lone RadioButton, but it's setup is done sepearately
        self.epRad = RadioButton(totalButtons: 2, buttonSize: buttonSize, backgroundTexture: nil)
        
        // Created this to store the total buttons for the appropriate radio buttons
        //  Not having the inits() take up one line each was bugging my OCD
        let radBtnOpts = ["shpRad": Settings.Starships.shieldHP.one.elements.count,
                          "soRad":  Settings.Starships.shieldsAreOffset.one.elements.count,
                          "pmcRad": Settings.Starships.projectileMaxCharge.one.elements.count]
        
        // Inits the pairs containing interactive entities
        //  The colSel pair needed individual element initialisers as they had different start indexes
        self.colSel = Pair(Selector(displaySize: buttonSize, startIndex: 0),
                           Selector(displaySize: buttonSize, startIndex: 1))
        
        self.ssSel  = Pair(of: Selector(displaySize: buttonSize, startIndex: 0))
        self.shpRad = Pair(of: RadioButton(totalButtons: radBtnOpts["shpRad"]!, buttonSize: buttonSize))
        self.soRad  = Pair(of: RadioButton(totalButtons: radBtnOpts["soRad"]!,  buttonSize: buttonSize))
        
        self.ccSel  = Pair(of: Selector(displaySize: buttonSize, startIndex: 0))
        self.crSel  = Pair(of: Selector(displaySize: buttonSize, startIndex: 0))
        
        self.pctSel = Pair(of: Selector(displaySize: buttonSize, startIndex: 0))
        self.pmcRad = Pair(of: RadioButton(totalButtons: radBtnOpts["pmcRad"]!, buttonSize: buttonSize))
        
        self.fcSel  = Pair(of: Selector(displaySize: buttonSize, startIndex: 0))
        self.frtSel = Pair(of: Selector(displaySize: buttonSize, startIndex: 0))
        
        //
        self.allInters  = [epRad, colSel, shpRad, ssSel, soRad, ccSel, crSel, pmcRad, pctSel, fcSel, frtSel]
            as [Any]
        self.twoStaters = [colSel, ssSel, shpRad, soRad, ccSel, crSel, pmcRad, pctSel, fcSel, frtSel]
            as [Any]
        
        super.init(.west)///, scrollBarWidthMultiplier: 0.1)
        
        
        // Does setup for the lone RadioButton
        epRad.setButtonLabels(["YES", "NO"], constraint: SettingsDisplayConstraints.labelConstraint)
        epRad.setCurrentButton(0)
        epRad.setButtonCommands([
            { [weak self] in self?.equalisePlayers(true);  print("EQUALISE PLAYERS set to: true")  },
            { [weak self] in self?.equalisePlayers(false); print("EQUALISE PLAYERS set to: false") }
        ])
        
        // Sets up options and commands for colour selectors
        //  Removes matching colours from each element in pair
        var colours = Pair(of: SKTexture.TeamColours.allCases)
        colours.one.removeAll(where: { $0 == Settings.Starships.colours.two.value })
        colours.two.removeAll(where: { $0 == Settings.Starships.colours.one.value })
        
        //  Creates and sets commands list (one closure for each colour)
        for team in Team.allCases {
            colSel.get(team).setCommands(colours.get(team).map {
                colour in {
                    [weak self] in
                    // Modifies Settings and re-instantiates colour selectors with exclusive options
                    Settings.Starships.colours.forElement(team, modWith: { $0.setIndex(toOption: colour) })
                    self?.resetColourSelectors(displaySize: buttonSize)
                    print("COLOUR for TEAM \(team) set to: \(colour)")
                }
            })
        }
        
        
        // Adds interactives and labels
        for (i, (text, pairOrRad)) in zip(labelText, allInters).enumerated() {
            
            // Helpful values to compute positions
            /// TODO: Change the maskSize to the value of the full legth of the scroll display
            let maskHeight = Display.size(ofPole: .west).height
            let ySpacing   = (maskHeight / CGFloat(allInters.count))
            
            // Positions for the interactives and their labels
            //  This is for the first of the pair
            let interPos = CGPoint(x: SettingsDisplayConstraints.xOffset,
                                   y: (maskHeight / 2) - (ySpacing * CGFloat(i)))
            //  Stores positions for both in a pair
            let positionPair = Pair(interPos, interPos - CGPoint(x: 0, y: buttonSize.height * 1.1))
            
            // Creates and sets up label
            let label = SKLabelNode(text, constraint: SettingsDisplayConstraints.labelConstraint)
            label.horizontalAlignmentMode = .left
            label.position = interPos + CGPoint(x: 0, y: SettingsDisplayConstraints.labelSpacing)
            rootNode.addChild(label)
            
            // Sets positions of interactive pairs
            if let pair = pairOrRad as? Pair<Selector> {
                for (interactive, position) in zip(pair, positionPair) {
                    print(interactive.spriteComp.node.getAccFramePosition(ofSector: .left))
                    interactive.spriteComp.node.setAccFramePosition(anchorPoint: .left, position: position)
                    rootNode.addChild(interactive.spriteComp.node)
                }
            } else if let pair = pairOrRad as? Pair<RadioButton> {
                for (interactive, position) in zip(pair, positionPair) {
                    interactive.spriteComp.node.setAccFramePosition(anchorPoint: .left, position: position)
                    rootNode.addChild(interactive.spriteComp.node)
                }
                
            // For the lone radio button
            } else if let epRad = pairOrRad as? RadioButton {
                epRad.spriteComp.node.setAccFramePosition(anchorPoint: .left, position: positionPair.one)
                rootNode.addChild(epRad.spriteComp.node)
            
            // For anything else unexpected
            } else {
                fatalError(
                    "Expected a Pair<Selector>, Pair<RadioButton> or RadioButton object. Got \(pairOrRad)")
            }
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // Re-instantiates colour selectors every time a colour is chosen to ensure that each player cannot select the colour the other is currently on
    private func resetColourSelectors(displaySize size: CGSize) {
        
        // The colours available to each team after removing the colour the other team is set to
        let pair = Pair(Settings.Starships.colours.one.activeElements,
                        Settings.Starships.colours.two.activeElements)
        
        for (team, colours) in zip(Team.allCases, [pair.one, pair.two]) {
            
            let startIndex = colours.firstIndex(of: Settings.Starships.colours.get(team).value)!
            
            // Creates new selector with appropriate start index and commands
            let newSel = Selector(displaySize: size, startIndex: startIndex, backgroundTexture: nil)
            newSel.setCommands(colours.map {
                colour in {
                    [weak self] in
                    Settings.Starships.colours.forElement(team, modWith: { $0.setIndex(toOption: colour) })
                    // Safe to force unwrap as the constraints are constants
                    self?.resetColourSelectors(displaySize: size)
                }
            })
            
            // Inits new selector with the properties of the last one
            let oldSelPos = colSel.get(team).spriteComp.node.position
            let optLblPos = colSel.one.labels.first?.position ?? CGPoint.zero
            let selLblPos = colSel.one.selectors.one.spriteComp.label?.position ?? CGPoint.zero
            
            newSel.spriteComp.node.position = oldSelPos
            newSel.setOptionLabels(colours.map  { $0.rawValue },
                                   position:     optLblPos,
                                   constraint:   colSelLabelConst)
            newSel.setSelectorLabels(colSel.one.labelType,
                                     constraint: colSelSelectorConst,
                                     position:   selLblPos)
            
            // Removes old and adds new selector
            colSel.forElement(team, modWith: {
                // Not sure if the sprite needs to be removed first, did it just in case
                $0.spriteComp.node.removeFromParent()
                $0 = newSel
                spriteComp.node.addChild($0.spriteComp.node)
            })
        }
        
    }
    
    // Sets state of interactives for team two
    private func equalisePlayers(_ bool: Bool) {
        
        // Modifies settings appropriately
        Settings.Starships.areEqual = bool
        // Iterates over the pairs containing interactives to be set
        for pair in twoStaters {
            
            // Casts to Pair type and gets the appropriate state to set to
            if let pair = pair as? Pair<Any> {
                let state: Switch = (bool) ? .inactive : .active
                
                // Casts the second item in the pair and sets state
                if let radTwo = pair.two as? RadioButton {
                    radTwo.setState(state)
                } else if let selTwo = pair.two as? Selector {
                    selTwo.setState(state)
                }
            }
            
        }
        
    }
    
    
}

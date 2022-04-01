//
//  RadBtn.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 17/3/21.
//

import SpriteKit
import GameplayKit


// Contains a list of buttons to be toggled between
class RadioButton: UnSGEntity, InteractiveEntity, IsTwoState {
    
    typealias State = Switch
    var currentState: State = .active
    
    // Sub-buttons contained by self
    let subButtons: [SubButton]
    //
    let buttonSize: CGSize
    //
    var currentIndex: Int?
    var currentButton: SubButton? {
        get {
            
            if let i = self.currentIndex { return self.subButtons[i] } else { return nil }
        }
    }
    
    // The background. All sub-buttons are added to this
    let spriteComp = SpriteComponent()
    //
    let isHorizontal: Bool
    //
    let borderWidth: CGFloat
    let dividerWidth: CGFloat
    
    //
    var interactionEnabled: Bool {
        get {
            return (subButtons[0].spriteComp.base?.isUserInteractionEnabled)!
            
        } set(bool) {
            for button in subButtons {
                // Sets interaction of subButtons
                button.spriteComp.base?.isUserInteractionEnabled = bool
            }
        }
    }
    
    
    init(totalButtons: Int, buttonSize: CGSize,
         arrangeHorizontally: Bool = true,
         borderWidth: CGFloat = 0,
         dividerWidth: CGFloat = 0,
         backgroundTexture: SKTexture? = SKTexture.square(.white),
         buttonBorderWidth: CGFloat = 0) {
        
        // Sanity check
        // Also ensures that the copy() method can force unwrap the subButton array
        guard totalButtons >= 2
            else { fatalError("Attempted to create RadioButton with \(totalButtons) buttons. Must have at least two") }
        
        //
        self.buttonSize   = buttonSize
        self.borderWidth  = borderWidth
        self.dividerWidth = dividerWidth
        self.isHorizontal = arrangeHorizontally
        
        // Calculates size of sprite component background
        //  Did this here as it was so long and was repeated
        let backgroundSize: CGSize
        let borders = (borderWidth * 2) + (dividerWidth * CGFloat(totalButtons))
        if arrangeHorizontally {
            backgroundSize = CGSize(width: (buttonSize.width * CGFloat(totalButtons)) + borders,
                                    height: buttonSize.height + (borderWidth * 2))
        } else {
            backgroundSize = CGSize(width: buttonSize.width + (borderWidth * 2),
                                    height: (buttonSize.height * CGFloat(totalButtons)) + borders)
        }
        
        if let texture = backgroundTexture {
            let background = SKSpriteNode()
            background.size    = backgroundSize
            background.texture = texture
            background.setLayer(.iconBase)
            spriteComp.node.addChild(background, withName: SpriteComponent.baseKey)
        }
        
        // As subButtons is immutable, creates a mutable array to initialise it with
        var allButtons: [SubButton] = []
        for i in 0...totalButtons - 1 {
            // Initialises a sub-button
            let button = SubButton(i, size: buttonSize, borderWidth: buttonBorderWidth)
            
            // Sets position of sub-button
            //  Had to break the psoitions up into smaller values then add them together since the compiler couldn't handle them all at once
            let pos: CGPoint
            if arrangeHorizontally {
                let valOne: CGFloat = (buttonSize.width * CGFloat(i)) + (dividerWidth * CGFloat(i))
                let valTwo: CGFloat = (buttonSize.width / 2) - (backgroundSize.width / 2)
                pos = CGPoint(x: valOne + valTwo + borderWidth, y: 0)
            } else {
                let valOne: CGFloat = (buttonSize.height * CGFloat(i)) + (dividerWidth * CGFloat(i))
                let valTwo: CGFloat = (buttonSize.height / 2) - (backgroundSize.height / 2)
                // The y pos is multiplied by -1 so buttons that are arranged from top to bottom
                pos = CGPoint(x: 0,  y: (valOne + valTwo + borderWidth) * -1)
            }
            button.spriteComp.node.position = pos
            
            // Adds as child and appends to array
            spriteComp.node.addChild(button.spriteComp.node, withName: "SubButton\(i)")
            allButtons.append(button)
        }
        
        self.subButtons = allButtons
        
        super.init()
        // Adds components
        addComponent(spriteComp)
        // Adds entities
        addEntities(subButtons)
        
        setCurrentButton(0)
    }
    
    // For the Pair structs in Starship Settings
    override func copy(with zone: NSZone? = nil) -> Any {
        return RadioButton(totalButtons: subButtons.count, buttonSize: buttonSize,
                           arrangeHorizontally: isHorizontal,
                           borderWidth: borderWidth, dividerWidth: dividerWidth,
                           backgroundTexture: spriteComp.base?.texture ?? nil,
                           buttonBorderWidth: subButtons[0].borderWidth)
    }
    
    // Calls addLabel() method for each subButton
    //  NOTE: Make sure that the length of the text array is not longer than the subButton array
    func setButtonLabels(_ text: [String], constraint: SKLabelNode.SizeConstraint,
                         alignment: SKLabelHorizontalAlignmentMode = .center,
                         position: CGPoint = CGPoint(x: 0, y: 0)) {
        
        for (i, str) in text.enumerated() {
            subButtons[i].setLabel(str, constraint: constraint, alignment: alignment, position: position)
        }
    }
    
    // Sets the command property for the command component of each sub button
    //  NOTE: - This method has the same problem as setButtonLabels()
    //        - Every sub button will have the setCurrentButton() method appended to their commands
    func setButtonCommands(_ commands: [Command]) {
        
        // Iterates over commands passed
        for (i, command) in commands.enumerated() {
            
            // Creates and assigns a closure to the sub-button that runs the
            // specified command and sets the sub button as the curent button
            subButtons[i].setCommand({
                [weak self] in
                command()
                self?.setCurrentButton(i)
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // Sets background colour and user interaction of sub-buttons and self
    func setState(_ state: State) {
        
        // Turns all the buttons off
        setCurrentButton(nil)
        
        if state == .active {
            spriteComp.base?.texture = SKTexture.square(.white)
            interactionEnabled = true
        } else {
            spriteComp.base?.texture = SKTexture.square(.grey, .dark)
            interactionEnabled = false
        }
        
    }
    
    
    // Sets currentButton property and button state of the current button to .on and the rest to .off
    // - The argument is optional, so leave as nil if all buttons must be set to .off
    func setCurrentButton(_ index: Int?) {
        currentIndex = index
        for button in subButtons {
            let state: Button.State = (button.index == index) ? .on : .off
            button.setState(state)
        }
        
    }
    
    
}

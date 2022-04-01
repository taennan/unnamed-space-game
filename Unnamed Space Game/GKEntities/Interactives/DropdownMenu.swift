//
//  DropdownMenu.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 15/1/21.
//

import GameplayKit
import SpriteKit

// Presents the players with a menu of options to be toggled between
class DropdownMenu: UnSGEntity, RespondsToScrollEvents, InteractiveEntity {
    
    //
    enum State {
        case on
        case off
        
        case inactive
    }
    var currentState: State = .off
    
    //
    enum DropdownLabel {
        case arrow
        case plusminus
    }
    
    
    // RadioButton entity acting as the dropdown menu
    //  Must add labels to each subButton manually by calling it's addLabel() method
    let menu: RadioButton
    
    // Amount of subButtons the dropdown menu can display at once
    let buttonsDisplayable: Int
    // Direction the dropdown menu appears from (above or below)
    var dropsDown: Bool
    
    
    // You know what they do...
    let spriteComp = SpriteComponent()
    //
    let cropComp: CropComponent?
    let scrollComp: ScrollComponent?
    
    
    // The background sprite for the menu
    let dropBackground: InteractiveSprite
    static let dropBackKey: String = "dropdownbackground"
    
    
    // Displays text showing which sub-button is currently activated
    let display: Button
    static let displayKey: String = "displaybutton"
    
    // Sets state of dropdown menu when pressed
    let dropdownButton: Button
    static let dropdownKey: String = "dropdownbutton"
    //
    var dropdownLabelType: DropdownLabel = .plusminus
    
    
    // Helpful stored properties
    let borderWidth: CGFloat
    let dividerWidth: CGFloat
    
    //
    private let backgroundTexture: SKTexture?
    
    //
    var interactionEnabled: Bool {
        get {
            return display.interactionEnabled
        } set(bool) {
            menu.interactionEnabled = bool
            dropdownButton.interactionEnabled = bool
            display.interactionEnabled = bool
        }
    }
    
    
    init(totalButtons: Int, buttonsDisplayable: Int, buttonSize: CGSize,
         // Preset arguments
         borderWidth: CGFloat = 2,
         dividerWidth: CGFloat = 1,
         dropsDown: Bool = true,
         backgroundTexture: SKTexture? = SKTexture.square(.white)) {
        
        // Sets the helpful stored properties
        self.dropsDown = dropsDown
        self.buttonsDisplayable = buttonsDisplayable
        self.dividerWidth = dividerWidth
        self.borderWidth = borderWidth
        self.backgroundTexture = backgroundTexture
        
        
        // Creates a background for the sprite component
        let base = SKSpriteNode()
        base.texture = backgroundTexture
        base.size = CGSize(width: buttonSize.width + buttonSize.height + borderWidth * 3,
                           height: buttonSize.height + borderWidth * 2)
        base.setLayer(.iconBase)
        spriteComp.node.addChild(base, withName: SpriteComponent.baseKey)
        
        
        //
        self.dropBackground = InteractiveSprite(texture: backgroundTexture,
                                                size: CGSize(width: base.size.width,
                                                             height: (buttonSize.height + dividerWidth) *
                                                                      CGFloat(buttonsDisplayable) + (borderWidth * 2)))
        dropBackground.setLayer(.dropdownBase)
        if self.dropsDown {
            dropBackground.position.y = base.frame.minY + dropBackground.frame.minY + borderWidth
        } else {
            dropBackground.position.y = base.frame.maxY + dropBackground.frame.maxY  - borderWidth
        }
        
        // Initialises RadioButton() object to display options and adds to crop component
        self.menu = RadioButton(totalButtons: totalButtons,
                                buttonSize: buttonSize,
                                arrangeHorizontally: false,
                                borderWidth: 0,
                                dividerWidth: dividerWidth,
                                backgroundTexture: nil)
        menu.spriteComp.node.position.x = -(base.size.width / 2) + (buttonSize.width / 2) + borderWidth
        // Increases the zPosition of sub buttons
        for button in menu.subButtons {
            let body = button.spriteComp.body
            body?.setLayer(.dropdownBody)
        }
        
        
        // Sets up crop and scroll components
        if buttonsDisplayable < totalButtons {
            
            // Creates a mask for the crop component
            let mask = SKSpriteNode()
            mask.texture = SKTexture()
            mask.size = CGSize(width: dropBackground.size.width - (borderWidth * 2),
                               height: dropBackground.size.height - (borderWidth * 2))
            // Crop component
            self.cropComp = CropComponent(maskNode: mask)
            cropComp?.cropNode.setLayer(.dropdownBase)
            cropComp?.cropNode.addChild(menu.spriteComp.node)
            
            // Scroll component
            self.scrollComp = ScrollComponent(barSize: CGSize(width: buttonSize.height,
                                                              height: mask.size.height),
                                              scrollerStartsHigh: dropsDown)
            // Sets up scroll bar
            scrollComp?.bar.spriteComp.node.position.x = mask.frame.maxX - (buttonSize.height / 2)
            cropComp?.cropNode.addChild(scrollComp!.bar.spriteComp.node, withName: ScrollComponent.barKey)
            
            // Sets up dropdown background
            dropBackground.addChild(cropComp!.cropNode)
            dropBackground.setEventsHandled([.scrollWheel])
            
        } else {
            // Sets components as nil
            self.cropComp = nil
            self.scrollComp = nil
            
            // Creates a sprite to act as a placeholder for the scrollbar
            let fakeBar = SKSpriteNode()
            fakeBar.texture = SKTexture.square(.grey, .dark)
            fakeBar.position.x = dropBackground.frame.maxX - borderWidth - (buttonSize.height / 2)
            fakeBar.size = CGSize(width: buttonSize.height,
                                  height: dropBackground.size.height - (borderWidth * 2))
            fakeBar.setLayer(.dropdownBody)
            
            // Adds sprites to dropdown background
            dropBackground.addChild(fakeBar, withName: ScrollComponent.barKey)
            dropBackground.addChild(menu.spriteComp.node)
        }
        
        
        // Initialises the display sprite
        self.display = Button(size: buttonSize,
                              handlesMouseEvents: nil)
        display.interactionEnabled = false
        display.spriteComp.node.position.x = (-base.size.width / 2) + (buttonSize.width / 2) + borderWidth
        spriteComp.node.addChild(display.spriteComp.node)
        
        // Initialises the dropdown button and set multiple presses to true
        self.dropdownButton = Button(size: CGSize(width: buttonSize.height, height: buttonSize.height))
        dropdownButton.multiplePressesEnabled = true
        dropdownButton.spriteComp.node.position.x = base.frame.maxX - (buttonSize.height / 2) - borderWidth
        spriteComp.node.addChild(dropdownButton.spriteComp.node)
        
        
        super.init()
        // Adds components
        addComponent(spriteComp)
        if let comp = cropComp { addComponent(comp) }
        if let comp = scrollComp { addComponent(comp) }
        // Adds entities
        addEntities([display,
                     dropdownButton,
                     menu])
        
        
        // Sets command for dropdown button
        dropdownButton.setCommand({ [weak self] in self?.setState(.on) })
        // Sets scrolled node for scroll component
        scrollComp?.setScrolledNode(menu.spriteComp.node)
        // Sets entity for dropdown background
        dropBackground.entity = self
    }
    
    
    // Calls the matching method from the RadioButton() object
    // NOTE: See RadioButton() for warnings about these methods
    func setButtonLabels(_ text: [String], constraint: SKLabelNode.SizeConstraint,
                         position: CGPoint = CGPoint(x: 0, y: 0)) {
        
        menu.setButtonLabels(text, constraint: constraint, alignment: .left, position: position)
        
        // Increases the zPosition of button labels
        for button in menu.subButtons { button.spriteComp.label?.setLayer(.dropdownInfo) }
    }
    
    // Creates and sets a command for each sub button which also sets the text of the display
    func setButtonCommands(_ commands: [Command]) {
        
        // Creates an empty array to append commands to
        var newCommands: [Command] = []
        // Creates a command for each button and appends to array
        for (i, command) in commands.enumerated() {
            let newCommand: Command = {
                [weak self] in
                self?.display.spriteComp.label?.text = self?.menu.subButtons[i].spriteComp.label?.text
                command()
            }
            newCommands.append(newCommand)
        }
        
        // Calls matching method from RadioButton() object
        menu.setButtonCommands(newCommands)
    }
    
    
    // Sets or resets the label of the dropdown button
    func setDropdownLabel(_ text: DropdownLabel, constraint: SKLabelNode.SizeConstraint,
                          position: CGPoint = CGPoint(x: 0, y: 0)) {
        
        self.dropdownLabelType = text
        
        let str: String
        if text == .arrow {
            str = ">"
        } else {
            if currentState == .on { str = "-" } else { str = "+" }
        }
        dropdownButton.setLabel(str, constraint: constraint, position: position)
        
        if text == .arrow {
            if currentState == .on {
                dropdownButton.spriteComp.label?.zRotation = Angle(deg: 90).value
            } else {
                dropdownButton.spriteComp.label?.zRotation = Angle(deg: -90).value
            }
            // Inverts if the menu pops up instead of dropping down
            if !self.dropsDown { dropdownButton.spriteComp.label?.zRotation *= -1 }
        }
        
    }
    
    
    // Sets and displays current button
    func setCurrentButton(_ index: Int) {
        
        // Calls setCurrentButton() from RadioButton() object
        menu.setCurrentButton(index)
        
        // Sets the label of the display button to match the current button
        if let label = menu.currentButton?.spriteComp.label {
            display.setLabel(label.text ?? "ERROR",
                             constraint: .fontSize(label.fontSize),
                             position: CGPoint(x: 0, y: label.position.y))
            setDisplayLabelColour()
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // Sets background colours and toggles the dropdown menu
    func setState(_ state: State) {
        
        // Sets currentState property
        self.currentState = state
        // Enables user interaction and sets background texture
        interactionEnabled = true
        spriteComp.base?.texture = backgroundTexture
        
        // Sets background size, colour and user interaction
        if state == .on {                    // Activates menu
            
            // Resets state and adds dropdown menu
            self.currentState = state
            spriteComp.node.addChild(dropBackground, withName: DropdownMenu.dropBackKey)
            
            // Resets command and label of dropdown button and display
            dropdownButton.commandComp.command = { self.setState(.off) }
            if let label = dropdownButton.spriteComp.label {
                setDropdownLabel(dropdownLabelType,
                                 constraint: .fontSize(label.fontSize),
                                 position: label.position)
            }
            
        } else if state == .off {           // De-activates menu
            
            // Removes dropdown menu
            dropBackground.removeFromParent()
            
            // Resets command and label of dropdown button and display
            dropdownButton.commandComp.command = { self.setState(.on) }
            if let label = dropdownButton.spriteComp.label {
                setDropdownLabel(dropdownLabelType,
                                 constraint: .fontSize(label.fontSize),
                                 position: label.position)
            }
            
        } else {                            // Sets inactive
            
            // Disables user interaction and sets background texture
            interactionEnabled = false
            spriteComp.base?.texture = SKTexture.square(.grey, .dark)
            
            // Resets font colours of display label
            dropdownButton.spriteComp.label?.fontColor = Colours.lightGrey
            
            // Removes dropdown menu
            dropBackground.removeFromParent()
        }
        
        //
        setDisplayLabelColour()
        
    }
    
    
    // Does what it says
    private func setDisplayLabelColour() {
        let colour = (currentState == .on) ? Colours.white : Colours.lightGrey
        display.spriteComp.label?.fontColor = colour
    }
    
    // Calls scrollWheel() method in scroll component
    func scrollWheel(by amount: CGFloat) {
        scrollComp?.scroll(by: amount)
    }
    
    
}

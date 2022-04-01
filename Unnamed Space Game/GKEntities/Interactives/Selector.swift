//
//  Selector.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 8/3/21.
//

import SpriteKit
import GameplayKit

// Displays a set of options which can be toggled between
//  NOTE: To properly initialise, setSelectorLabels() must be called AFTER the setLabels() and setCommands() methods
class Selector: UnSGEntity, InteractiveEntity, IsTwoState {
    
    typealias State = Switch
    var currentState = State.active
    
    var interactionEnabled: Bool {
        get {
            // Didn't grab value from selectors as their interactivity always changes
            return self.display.interactionEnabled
        } set(bool) {
            for selector in self.selectors { selector.interactionEnabled = bool }
            display.interactionEnabled = bool
        }
    }
    
    let spriteComp = SpriteComponent()
    //
    var borderWidth: CGFloat
    private let backgroundTexture: SKTexture
    
    // Buttons used to toggle between options
    let selectors: Pair<Button>
    // The types of labels used by selectors
    enum SelectorLabels {
        case plusminus
        case arrows
        case doubleArrows
    }
    // Inited with a defualt value
    // - This is just for the Starship Setting Display
    var labelType: SelectorLabels = .arrows
    
    // A Button used to display the current option
    let display: Button
    
    // Whether the current index is capped or looped when it reaches the ends of the command array
    let doesLoop: Bool
    
    // Stores commands and label objects to be accessed with the currentIndex property
    var labels: [SKLabelNode] = []
    var commands: [Command] = []
    // The index at which labels and commands are called
    var currentIndex: Int
    
    
    init(displaySize: CGSize,
         borderWidth: CGFloat = 0,
         doesLoop:    Bool = true,
         startIndex:  Int = 0,
         backgroundTexture: SKTexture? = SKTexture.square(.white)) {
        
        //
        self.currentIndex = startIndex
        self.doesLoop = doesLoop
        self.borderWidth = borderWidth
        self.backgroundTexture = (backgroundTexture != nil) ? backgroundTexture! : SKTexture()
        
        self.display = Button(size: displaySize, handlesMouseEvents: nil)
        display.setState(.on)
        
        let selectorSize = CGSize(squareOfWidth: displaySize.height)
        self.selectors   = Pair(Button(size: selectorSize), Button(size: selectorSize))
        
        let background = SKSpriteNode()
        background.texture = backgroundTexture
        background.size = CGSize(width: displaySize.width + (selectorSize.width * 2) + (borderWidth * 4),
                                 height: displaySize.height + (borderWidth * 2))
        background.setLayer(.iconBase)
        spriteComp.node.addChild(background, withName: SpriteComponent.baseKey)
        
        
        super.init()
        // Adds components
        addComponent(spriteComp)
        // Adds entities
        addEntities(selectors + [display])
        
        // Adds Button() objects to sprite component
        spriteComp.node.addChild(display.spriteComp.node)
        for selector in selectors {
            // Allows multiple presses for selectors
            selector.multiplePressesEnabled = true
            spriteComp.node.addChild(selector.spriteComp.node)
        }
        
        // Sets commands and positions for selectors
        for (i, sel) in zip([-1, 1], selectors) {
            sel.setCommand({ [weak self] in self?.modCurrentIndex(by: i) })
            if let baseWidth = spriteComp.base?.size.width {
                let i = CGFloat(i)
                sel.spriteComp.node.position.x = (i * baseWidth / 2) - (i * selectorSize.width / 2) - (i * borderWidth)
            }
        }
        // Stops self from looping
        if !doesLoop { selectors.one.setState(.inactive) }
    }
    
    // For the Pair structures in Starship Settings
    override func copy(with zone: NSZone? = nil) -> Any {
        guard let bodySize = display.spriteComp.body?.size
            else { fatalError("Attempted to call copy() on Selector which has no display size") }
        return Selector(displaySize: bodySize,
                        borderWidth: borderWidth,
                        doesLoop: doesLoop,
                        startIndex: currentIndex,
                        backgroundTexture: backgroundTexture)
    }
    
    // Sets the warning message printed by the safetyCheck() method
    private enum Check {
        case length
        case postInit
    }
    // Checks if enough options have been added to arrays
    private func safetyCheck(_ array: Array<Any>, for check: Check) {
        if array.count <= 2 {
            if check == .length {
                print("ERROR: Selector() objects are not configured to work with \(array.count) options. Try to put at least 3 options or use a RadioButton() instead")
            } else {
                print("ERROR: Array \(array) not properly set in Selector() object before setSelectorLabels() method was called")
            }
        }
    }
    
    
    // Fills commands array with, well... commands
    func setCommands(_ commands: [Command]) {
        // Safety check
        safetyCheck(commands, for: .length)
        // Sets commands
        self.commands = commands
    }
    
    //
    func setOptionLabels(_ text: [String],
                         position: CGPoint = CGPoint(x: 0, y: 0),
                         constraint: SKLabelNode.SizeConstraint) {
        // Safety check
        safetyCheck(text, for: .length)
        
        // Creates and adds labels to array
        for str in text {
            let label = SKLabelNode(str, fontColour: Colours.white, constraint: constraint)
            label.position = position
            labels.append(label)
        }
        
        // Sets label for display
        setCurrentLabel(currentIndex)
    }
    
    // Adds labels to the selector buttons
    // NOTE: This method must be called after the above two to properly initialise
    func setSelectorLabels(_ labelType: SelectorLabels, constraint: SKLabelNode.SizeConstraint,
                           position: CGPoint = CGPoint(x: 0, y: 0)) {
        // Checks if arrays have been set appropriately before setting the selector labels
        safetyCheck(commands, for: .postInit)
        safetyCheck(self.labels, for: .postInit)
        
        //
        let labels: Pair<String>
        switch labelType {
        case .plusminus:
            labels = Pair("-", "+")
        case .arrows:
            labels = Pair("<", ">")
        case .doubleArrows:
            labels = Pair("<<", ">>")
        }
        
        // Adds labels to selectors and sets their positions
        if labelType == .plusminus {
            selectors.two.setLabel(labels.two, constraint: constraint, position: position)
            selectors.one.setLabel(labels.one,
                                   constraint: .fontSize(selectors.two.spriteComp.label!.fontSize),
                                   position: position)
        } else {
            selectors.one.setLabel(labels.one, constraint: constraint, position: position)
            selectors.two.setLabel(labels.two, constraint: constraint, position: position)
        }
        
        self.labelType = labelType
        // Sets the interactivity of selectors appropriately
        modCurrentIndex(by: 0)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    //
    func setState(_ state: State) {
        
        self.currentState = state
        
        if state == .active {
            spriteComp.base?.texture = backgroundTexture
            interactionEnabled = true
            for sel in selectors { sel.setState(.on) }
            modCurrentIndex(by: 0)
        } else {
            spriteComp.base?.texture = SKTexture.square(.grey, .dark)
            interactionEnabled = false
            for sel in selectors { sel.setState(.inactive) }
        }
    }
    
    
    // Increments current index by specified amount then caps or loops it if it is out of range
    //  pass 1 as the argument to increment and -1 to decrement
    func modCurrentIndex(by int: Int) {
        
        // Increments index
        self.currentIndex += int
        
        // The indexes at the start and end of the command array
        let start: Int = 0
        let end: Int = commands.count - 1
        
        if self.doesLoop {
            // If out of range, sets current index back to the other end of the array
            if currentIndex < start {
                currentIndex = end
            } else if currentIndex > end {
                currentIndex = start
            }
            
        } else {
            // If at the ends of the array, sets interactivity of appropriate selector
            //  The label of the any selector being de-activated must have it's colour set manually as the inbuilt Button() methods change it to the wrong colour
            if currentIndex == start {
                selectors.one.setState(.inactive)
                selectors.one.spriteComp.label?.fontColor = Colours.buttonLabelColour(forState: .inactive)
            } else if currentIndex == end {
                selectors.two.setState(.inactive)
                selectors.two.spriteComp.label?.fontColor = Colours.buttonLabelColour(forState: .inactive)
                
            // If in the middle of the array, sets both selectors on
            } else {
                for selector in selectors { selector.setState(.on) }
            }
        }
        
        // Sets current label and runs current command if the current index was actually modified
        if int != 0 {
            setCurrentLabel(currentIndex)
            commands[currentIndex]()
        }
    }
    
    
    // Sets label for display
    //  NOTE: Do not pass an argument which will access an index which is out of range
    private func setCurrentLabel(_ index: Int) {
        let label: SKLabelNode = labels[index]
        display.setLabel(label.text ?? "ERROR",
                         constraint: .fontSize(label.fontSize),
                         position: label.position)
    }
    
    
}

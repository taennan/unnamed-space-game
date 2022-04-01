//
//  Button.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 20/12/20.
//

import GameplayKit
import SpriteKit


// An interactive sprite which runs a command when clicked
class Button: UnSGEntity, RespondsToMouseEvents, InteractiveEntity {
    
    //
    enum State {
        case on
        case off
        case hoverOn
        case hoverOff
        
        case inactive
    }
    var currentState: State = .off
    
    //
    var isPressed: Bool = false
    
    // The background
    let spriteComp = ButtonSpriteComponent()
    //
    let borderWidth: CGFloat
    // Keys likely to be needed to access sub-sprites
    static let bodyKey:  String = "body"
    static let labelKey: String = "label"
    static let iconKey:  String = "icon"
    
    // Contains commands to be run by self
    var commandComp = CommandComponent()
    //
    var multiplePressesEnabled: Bool = false
    //
    var interactionEnabled: Bool {
        get {
            return spriteComp.body?.isUserInteractionEnabled ?? false
        } set(bool) {
            spriteComp.body?.isUserInteractionEnabled = bool
        }
    }
    
    
    init(size: CGSize,
         // Preset arguments
        handlesMouseEvents: [InteractiveSprite.MouseEvents]? = [.mouseDown, .mouseUp, .mouseMoved],
        borderWidth: CGFloat = 0) {
        
        //
        self.borderWidth = borderWidth
        
        super.init()
        addComponent(spriteComp)
        addComponent(commandComp)
        
        
        // Adds sprites
        let interactive = InteractiveSprite(texture: SKTexture.buttonBodyTexture(forState: .off),
                                            size: CGSize(width: size.width - borderWidth,
                                                         height: size.height - borderWidth),
                                            entity: self)
        interactive.setEventsHandled(handlesMouseEvents)
        interactive.setLayer(.iconBody)
        spriteComp.node.addChild(interactive, withName: Button.bodyKey)
        
        // Only adds background if border width is set
        if borderWidth > 0 {
            let base = SKSpriteNode()
            base.texture = SKTexture.buttonBaseTexture(forState: .off)
            base.size = size
            base.setLayer(.iconBase)
            spriteComp.node.addChild(base, withName: SpriteComponent.baseKey)
        }
        
    }
    
    //
    func setLabel(_ text: String, constraint: SKLabelNode.SizeConstraint,
                  alignment: SKLabelHorizontalAlignmentMode = .center,
                  position: CGPoint = CGPoint(x: 0, y: 0)) {
        
        // Removes old label (if any...)
        spriteComp.label?.removeFromParent()
        // Creates a new label with specified properties
        let label: SKLabelNode
        if currentState == .on || currentState == .hoverOn ||
           (multiplePressesEnabled && currentState != .inactive) {
            label = SKLabelNode(text, fontColour: Colours.white, constraint: constraint)
        } else {
            label = SKLabelNode(text, fontColour: Colours.lightGrey, constraint: constraint)
        }
        
        // Sets alignment and position
        if let body = spriteComp.body {
            if alignment == .left {
                label.position.x = -body.size.width / 2
            } else if alignment == .right {
                label.position.x = body.size.width / 2
            }
            label.position.y = -label.frame.size.height / 2
        }
        label.position.x += position.x
        label.position.y += position.y
        label.setLayer(.iconInfo)
        
        // Adds label
        spriteComp.node.addChild(label, withName: Button.labelKey)
    }
    
    // Sets command closure of the command component
    func setCommand(_ command: @escaping Command) {
        commandComp.command = command
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // Changes background and label colur depending on how self is interacted with
    func setState(_ state: State) {
        
        // Sets interactivity from the current sate
        currentState = state
        interactionEnabled = (state == .inactive) ? false : true
        
        spriteComp.base?.texture    = SKTexture.buttonBaseTexture(forState: state)
        spriteComp.body?.texture    = SKTexture.buttonBodyTexture(forState: state)
        
        // Ensures that when multiple presses are enabled, the label is always white
        if currentState != .inactive && multiplePressesEnabled {
            spriteComp.label?.fontColor = Colours.buttonLabelColour(forState: .on)
        } else {
            spriteComp.label?.fontColor = Colours.buttonLabelColour(forState: state)
        }
        
    }
    
    
    // The following methods are called to respond to mouse events passed to self by the InteractiveSprite() object
    
    // Depresses button
    func mouseDown() {
        guard interactionEnabled && currentState != .on
            else { return }
        setState(.on)
        isPressed = true
    }
    // Runs command
    func mouseUp() {
        guard isPressed && interactionEnabled
            else { return }
        
        // Creates a fancy-pansy click action
        let wait = SKAction.wait(forDuration: 0.1)
        let flash = SKAction.run {
            [weak self] in
            self?.spriteComp.body?.texture = SKTexture.buttonBodyTexture(forState: .hoverOn)
        }
        let reset = SKAction.run {
            [weak self] in
            self?.spriteComp.body?.texture = SKTexture.buttonBodyTexture(forState: .on)
            self?.mouseMovedIn()
        }
        
        let seq = SKAction.sequence([flash, wait, reset])
        spriteComp.node.run(seq)
        
        // Does the important stuff
        isPressed = false
        commandComp.runCommand()
    }
    
    //
    func mouseMovedIn() {
        guard interactionEnabled
            else { return }
        
        if currentState == .on {
            setState(.hoverOn)
        } else if currentState == .off {
            setState(.hoverOff)
        }
        
        isPressed = false
    }
    //
    func mouseMovedOut() {
        guard interactionEnabled
            else { return }
        
        if currentState == .hoverOn {
            setState(.on)
        } else if currentState == .hoverOff {
            setState(.off)
        } else if currentState == .on && isPressed {
            setState(.off)
        }
        
        isPressed = false
    }
    
    
}



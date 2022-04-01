//
//  InteractiveSprite.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 17/3/21.
//

import SpriteKit
import GameplayKit


//
class InteractiveSprite: SKSpriteNode, RespondsToMouseEvents, RespondsToScrollEvents {
    
    enum MouseEvents: CaseIterable {
        case mouseDown
        case mouseUp
        case mouseMoved
        case scrollWheel
    }
    var handlesEvents: [MouseEvents: Bool] = [:]
    // Checks if the specified mouse event is set as true in the handles events dictionary
    func doesHandle(_ event: MouseEvents) -> Bool { return self.handlesEvents[event] ?? false }
    
    
    init(texture: SKTexture?, size: CGSize,
         // Preset arguments
        handlesEvents events: [MouseEvents]? = nil,
        entity: GKEntity? = nil) {
        
        super.init(texture: texture, color: .clear, size: size)
        self.isUserInteractionEnabled = true
        self.entity = entity
        self.setEventsHandled(events)
    }
    
    
    // This method can take arguments as nil or [] to set all events to false
    func setEventsHandled(_ mouseEvents: [MouseEvents]?) {
        // Sets all event types to false
        for event in handlesEvents.keys { handlesEvents[event] = false }
        
        // Resets specified mouse events to true
        if let events = mouseEvents { for event in events { handlesEvents[event] = true } }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // These are overriden to make up for the scene's inadequacy
    override func mouseDown(with event: NSEvent) { self.scene?.mouseDown(with: event) }
    
    override func mouseUp(with event: NSEvent) { self.scene?.mouseUp(with: event) }
    
    override func mouseDragged(with event: NSEvent) { (entity as? ScrollBar)?.mouseDown() }
    
    
    //
    private func mouseErr() {
        print("ERROR: Entity \(String(describing: entity)) of InteractiveSprite() does not conform to 'RespondsToMouseEvents'")
    }
    private func scrollErr() {
        print("ERROR: Entity \(String(describing: entity)) of InteractiveSprite() does not conform to 'RespondsToScrollEvents'")
    }
    
    func mouseDown() {
        guard self.doesHandle(.mouseDown) else { return }
        guard let entity = entity as? RespondsToMouseEvents else { mouseErr(); return }
        
        entity.mouseDown()
    }
    
    
    func mouseUp() {
        guard self.doesHandle(.mouseUp) else { return }
        guard let entity = entity as? RespondsToMouseEvents else { mouseErr(); return }
        
        entity.mouseUp()
    }
    
    func mouseMovedIn() {
        guard self.doesHandle(.mouseMoved) else { return }
        guard let entity = entity as? RespondsToMouseEvents else { mouseErr(); return }
        
        entity.mouseMovedIn()
    }
    
    func mouseMovedOut() {
        guard self.doesHandle(.mouseMoved) else { return }
        guard let entity = entity as? RespondsToMouseEvents else { mouseErr(); return }
        
        entity.mouseMovedOut()
    }
    
    
    func scrollWheel(by deltaY: CGFloat) {
        guard self.doesHandle(.scrollWheel) else { return }
        guard let entity = entity as? RespondsToScrollEvents else { scrollErr(); return }
        
        entity.scrollWheel(by: deltaY)
    }
    
    
}

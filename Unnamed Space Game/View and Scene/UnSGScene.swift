//
//  UnSGScene.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 7/12/20.
//

import SpriteKit
import GameplayKit


// Abstract scene class
class UnSGScene: SKScene, ContainsEntities {
    
    // A set of entities contained by self
    var entities: Set<UnSGEntity> = []
    
    // Adds specified entities to the set
    func addEntities(_ entities: [UnSGEntity]) {
        for entity in entities {
            self.entities.insert(entity)
            entity.entity = self
        }
    }
    // Removes specified entities from the set and sets their higher entities as nil
    func removeEntities(_ entities: [UnSGEntity]) {
        for entity in entities {
            entity.entity = nil
            self.entities.remove(entity)
        }
    }
    
    // Traverses downward through the entity tree and returns all entities of specified type
    // - Will resist the urge to document as it works the same way as the getDescendant() method
    func getLowerEntities<T>(ofType type: T.Type) -> [UnSGEntity] where T : UnSGEntity {
        
        var returnedEntities: [UnSGEntity] = []
        
        for entity in entities {
            if entity is T { returnedEntities.append(entity) }
            returnedEntities += entity.getLowerEntities(ofType: type)
        }
        
        return returnedEntities
    }
    
    
    // The Display entities to add to self
    var displays: [Pole: Display] = [:]
    
    // Adds specified displays to dictionary, adds sprite components and adds to entities set
    func setDisplays(_ displays: [Display]) {
        for display in displays {
            removeDisplays([display.pole])
            self.displays[display.pole] = display
            addChild(display.spriteComp.node)
            addEntities([display])
            display.didAddToScene()
        }
    }
    
    // Removes Display entities from self
    func removeDisplays(_ poles: [Pole]) {
        for pole in poles {
            displays[pole]?.spriteComp.node.removeFromParent()
            displays[pole]?.spriteComp.node.removeAllActions()
            displays[pole]?.removeFromEntity()
        }
    }
    
    static let backgroundColour = NSColor(calibratedRed: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    
    override func didMove(to view: SKView) {
        
        self.size = view.frame.size
        self.backgroundColor = UnSGScene.backgroundColour
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        // Instantiates and adds a tracking area to the view
        let trackingArea = NSTrackingArea(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: self.size),
                                          options: [.activeInKeyWindow, .mouseMoved],
                                          owner: self,
                                          userInfo: nil)
        view.addTrackingArea(trackingArea)
    }
    
    
    // NOTE:
    // - The scene (for reasons...) does not always register mouseDown events. Therefore, the mouseDown() method in InteractiveSprite() calls mouseDown() of self instead
    override func mouseDown(with event: NSEvent) { handleMouseEvent(.mouseDown, nsEvent: event) }
    
    override func mouseUp(with event: NSEvent) { handleMouseEvent(.mouseUp, nsEvent: event) }
    
    override func mouseMoved(with event: NSEvent) { handleMouseEvent(.mouseMoved, nsEvent: event) }
    
    // Calls appropriate mouse event methods for interactive sprites at event location
    private func handleMouseEvent(_ mouseEvent: InteractiveSprite.MouseEvents, nsEvent: NSEvent) {
        
        // Gets any interactives that contain the event location
        let allInts = self.getDescendants(ofType: InteractiveSprite.self)
        // Filters out any interactives that do not fulfill all conditions
        let filteredInteractives = allInts.filter { $0.contains(nsEvent.location(in: $0)) &&
                                                    $0.zPosition != Layers.dropdownBase.rawValue &&
                                                    $0.doesHandle(mouseEvent) }
        
        // Filters interactives used for dropdown menu backgrounds
        
        if mouseEvent == .mouseMoved {
            // Calls mouseMovedOut() to correctly set the states of Button() entities
            for int in allInts { int.mouseMovedOut() }
        }
        
        // Calls appropriate mouse event method for the interactive wth the highest zPosition
        if let high = filteredInteractives.getHigh() as? InteractiveSprite {
            switch mouseEvent {
            case .mouseDown:
                high.mouseDown()
                
            case .mouseUp:
                high.mouseUp()
                
            case .mouseMoved:
                high.mouseMovedIn()
            
            case .scrollWheel:          // <--- Used scrollWheel() method for this one
                return
            }
        
        // If no interactives were clicked, disables all dropdown menus
        } else {
            if mouseEvent == .mouseDown {
                disableDropdownMenus()
            }
        }
        
    }
    
    // Had to make a specific method for scrolling
    override func scrollWheel(with event: NSEvent) {
        
        for display in displays.values {
            
            let point = display.spriteComp.node.convert(event.location(in: self), from: self)
            if let _ = display.spriteComp.base?.contains(point) {
                
                // Gets any interactives that contain the event location\
                let allInts = display.spriteComp.node.getDescendants(ofType: InteractiveSprite.self)
                let touchedInts = allInts.filter { $0.contains(event.location(in: display.spriteComp.node)) &&
                                                   $0.doesHandle(.scrollWheel) }
                
                if let high = touchedInts.getHigh() as? InteractiveSprite {
                    high.scrollWheel(by: event.scrollingDeltaY)
                }
                
            }
        }
        
        // So that button states can be set to .hoverOn when scrolled over
        self.handleMouseEvent(.mouseMoved, nsEvent: event)
    }
    
    
    // Does what it says
    func getMousePositionFromWindow() -> CGPoint {
        
        if let mousePos = view?.window?.mouseLocationOutsideOfEventStream {
            return self.convertPoint(fromView: mousePos)
        } else {
            fatalError("Scene() cannot get mouse position from window as it is not added to a view or window")
        }
        
    }
    
    
    // Sets state of all dropdown menu entities to off if currently on
    func disableDropdownMenus() {
        
        // Iterates through all dropdown menu entities
        let dropmenus = getLowerEntities(ofType: DropdownMenu.self) as! [DropdownMenu]
        for drop in dropmenus {
            // Sets state to off if currently on
            if drop.currentState == .on {
                drop.setState(.off)
            }
        }
        
    }
    
    
    // Contains z-positions for use by self's children
    /// STC
    enum Layers: CGFloat {
        
        // Used for game displays
        case displayLower = 1,
        
        // Used for objects below all other contents in displays
        effectsLower,
        
        // Used by objects in game displays
        gravityField,
        magneticField,
        atmosphereBackground,
        projectiles,      // ----- Also used for tow cables (this may be subject to change)
        ships,
        shields,
        atmosphereForeground,
        planets,
        edges,
        
        // Used for menu displays
        displayUpper,    /// <--- May not need this
        
        // Used by contents of menu displays
        iconBase,        // --|
        iconBody,        //   |--- Used for layering buttons and console dials
        iconDetail,      // --|
        iconInfo,        // ------ Used for displaying text and console information
        
        // Used for DropdownMenu() objects for layering their sprites over others when activated
        dropdownBase,
        dropdownBody,
        dropdownInfo,
        
        // Used for objects above all other contents in displays
        effects,
        effectsUpper
    }

    
}

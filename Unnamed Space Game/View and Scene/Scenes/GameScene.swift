//
//  GameScene.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 12/3/21.
//

import SpriteKit


// Contains main game functionality
class GameScene: UnSGScene {
    
    private let contactDelegate = ContactDelegate()
    
    /// These can be set to private when necessary
    var map: Map?                 { return displays[.west] as? Map }
    var scoreboard: ScoreDisplay? { return displays[.east] as? ScoreDisplay }
    //
    func cockpit(_ team: Team) -> CockpitDisplay? {
        return ((team == .one) ? displays[.north] : displays[.south]) as? CockpitDisplay
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setDisplays([Settings.Game.map.init(),  // Instantiates map object from type specified in settings
                     NavTestDisp(),
                     ScoreDisplay(),
                     Display(.south)])
        
        physicsWorld.contactDelegate = contactDelegate
    }
    
    
    // The following deal with handling keyboard input for players
    // The update() method was decided upon because it could handle buffered events and was generally smoother
    
    // Detects keydown events and calls event handlers
    override func keyDown(with event: NSEvent) { self.handleKeyEvent(event) }
    override func keyUp(with event: NSEvent)   { self.handleKeyEvent(event) }
    
    //
    private func handleKeyEvent(_ event: NSEvent) {
        guard event.type == .keyDown || event.type == .keyUp
            else { return }
        map?.starships.forEach { $0.inputComp.addEvent(event) }
    }
    
    // Calls the update method of all necessary components of the Starships
    override func update(_ currentTime: TimeInterval) {
        map?.starships.forEach {
            $0.inputComp.update(deltaTime: currentTime)
            $0.cockpitLink.update(deltaTime: currentTime)
        }
        
    }
    
}

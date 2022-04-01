//
//  GameEntity.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 12/5/21.
//

import GameplayKit
import SpriteKit


//
class GameEntity: UnSGEntity, HandlesEntityContacts {
    
    //
    let spriteComp = SpriteComponent()
    let physComp = PhysicsComponent()
    
    //
    var startpoint: Startpoint?
    
    //
    var map: Map? { return self.getHigherEntities(ofType: Map.self).first as? Map }
    
    
    override init() {
        super.init()
        addComponent(spriteComp)
        addComponent(physComp)
        setStartpoint(Startpoint(x: 0, y: 0, angle: 0))
    }
    
    //
    func setStartpoint(_ startpoint: Startpoint) {
        self.startpoint = startpoint
        addComponent(startpoint)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // Meant to be overriden
    func didBeginContact(withConformingEntity entity: HandlesEntityContacts) {}
    func didEndContact(withConformingEntity entity: HandlesEntityContacts) {}
    
    
}

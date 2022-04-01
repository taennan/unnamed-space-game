//
//  UnSGEntityProtocols.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 8/5/21.
//

import GameplayKit

protocol ContainsEntities: AnyObject {
    
    var entities: Set<UnSGEntity> { get set }
    
    func addEntities(_ entities: [UnSGEntity])
    func removeEntities(_ entities: [UnSGEntity])
    
    func getLowerEntities<T>(ofType type: T.Type) -> [UnSGEntity]  where T: UnSGEntity
    
}

protocol ContainedByEntity: AnyObject {
    
    var entity: ContainsEntities? { get }
    
    func getHigherEntities<T>(ofType type: T.Type) -> [ContainsEntities]  where T: ContainsEntities
    
    func removeFromEntity()
    
}

protocol HandlesEntityContacts {
    
    func didBeginContact(withConformingEntity entity: HandlesEntityContacts)
    func didEndContact(withConformingEntity entity: HandlesEntityContacts)
    
}

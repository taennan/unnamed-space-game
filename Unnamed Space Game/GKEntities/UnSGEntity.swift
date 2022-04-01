//
//  UnSGEntity.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 11/5/21.
//

import GameplayKit


// Contains functionality to add and be added to other entities
// - All entities used in game will be a subclass of this
// - This object type can only deal with other UnSGEntity objects and subclasses
class UnSGEntity: GKEntity, ContainsEntities, ContainedByEntity {
    
    // The entity which self is added to
    weak var entity: ContainsEntities?
    // The entities added to self
    var entities: Set<UnSGEntity> = []
    
    
    // Adds specified entities to the set
    func addEntities(_ entities: [UnSGEntity]) {
        for entity in entities {
            entity.entity = self
            self.entities.insert(entity)
        }
    }
    //
    func removeEntities(_ entities: [UnSGEntity]) {
        for entity in entities {
            entity.entity = nil
            self.entities.remove(entity)
        }
    }
    
    // Removes self from higher entity's entity set
    func removeFromEntity() {
        entity?.entities.remove(self)
        self.entity = nil
    }
    
    
    // Progresses through the entity tree and returns entities of specfied type
    // - Will resist the urge to document these as they work the same way as the SKNode.getDescendants() method
    func getHigherEntities<T>(ofType type: T.Type) -> [ContainsEntities]  where T: ContainsEntities {
        var returnedEntities: [ContainsEntities] = []
        if let ent = entity {
            if ent is T { returnedEntities.append(ent) }
            if let highEnt = ent as? ContainedByEntity {
                returnedEntities += highEnt.getHigherEntities(ofType: type)
            }
            ///returnedEntities += ent.getHigherEntities(ofType: type)
        }
        return returnedEntities
    }
    func getLowerEntities<T>(ofType type: T.Type) -> [UnSGEntity] where T : UnSGEntity {
        var returnedEntities: [UnSGEntity] = []
        for entity in entities {
            if entity is T { returnedEntities.append(entity) }
            returnedEntities += entity.getLowerEntities(ofType: type)
        }
        return returnedEntities
    }
    
    
}

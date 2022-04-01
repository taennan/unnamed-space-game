//
//  Map.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 11/1/21.
//

import SpriteKit
import GameplayKit


// So that objects can be instantiated from their types
// - This is used by the Map type to get instantiated from the Game Scene
protocol VoidParameterInitable {
    init()
}


// Base west display class to add gameplay entities to
class Map: GameDisplay, VoidParameterInitable {
    
    class var name: String { return "ERROR: Must override name class property in subclass" }
    
    // The node to which all sprite will be added to
    override var rootNode: SKNode {
        return (cropComp != nil) ? cropComp!.cropNode : spriteComp.node
    }
    
    //
    var cropComp: CropComponent?
    // For map bounds and geometry
    var boundsComp: MapBoundaryComponent?
    
    //
    var starships: Pair<Starship>
    
    // Used to determine the sizes of the starships within self
    // - The raw value is multiplied with the width of self to get the starships' width
    enum Scale: CGFloat {
        case small  = 0.03
        case medium = 0.05
        case large  = 0.08
    }
    
    // These ones are fairly self descriptive
    var gameEnded: Bool = false
    var score: Pair<Int> = Pair(of: 0)
    var roundsCompleted: Int = 0
    
    
    init(starshipScale: CGFloat, startpoints: [Startpoint]) {
        
        let size = Display.size(ofPole: .west)
        
        self.starships = Pair(Starship(.one, length: size.width * starshipScale),
                              Starship(.two, length: size.width * starshipScale))
        
        super.init(.west)
        
        for (startpoint, team) in zip(startpoints, Team.allCases) {
            starships.forElement(team, modWith: {
                [weak self] in
                // Adds to entity and node trees
                self?.addEntities([$0])
                self?.rootNode.addChild($0.spriteComp.node)
                // Moves to startpoint
                $0.setStartpoint(startpoint)
                $0.startpoint?.applyPositions()
            })
        }
        
        
        
        ///startGame()
    }
    
    convenience init(starshipScale: Scale, startpoints: [Startpoint]) {
        self.init(starshipScale: starshipScale.rawValue, startpoints: startpoints)
    }
    
    func setBoundary(_ boundary: MapBoundaryComponent) {
        
        for bound in boundary.boundaries {
            switch bound.boundaryType {     // <--- Must be a switch because of the associated values
            case .edge:
                self.cropComp = nil
            default:
                self.cropComp = CropComponent()
                break
            }
            
            spriteComp.node.addChild(bound.spriteComp.node)
            addEntities([bound])
        }
        
        // Creates and adds a mask node to the crop component
        /// Maybe the mask node can be set to the base?
        let mask = SKSpriteNode(texture: SKTexture(), color: .clear, size: spriteComp.base!.size)
        cropComp?.cropNode.maskNode = mask
        if let cropComp = cropComp {
            addComponent(cropComp)
            spriteComp.node.addChild(cropComp.cropNode)
        }
        
    }
    
    required init() { fatalError("ERROR: The required init from Map() MUST be overriden in subclasses") }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // Removes all actions and resets positions of all game entities
    func resetEntities() {
        
        for entity in getLowerEntities(ofType: GameEntity.self) as! [GameEntity] {
            entity.spriteComp.node.removeAllActions()
            entity.startpoint?.applyAll()
        }
        
    }
    
    
    // Runs explosion actions on specified starships and resets self
    /// TODO: Add actions and effects to make the transitions to startpoints cooler
    func starshipsWereDestroyed(fromTeams teams: [Team]) {
        
        // Runs destruction actions for all teams specified and increments points
        for team in teams {
            starships.get(team).destroy()
            score.forElement(team.other(), modWith: { $0 += 1 })
        }
        
        // Did not wrap this in an 'if' so that empty arrays can be used to increment round count in cases where all players need to survive
        roundsCompleted += 1
        
        //
        let action = SKAction.sequence([
            SKAction.wait(forDuration: 2),
            SKAction.run { [weak self] in self?.resetEntities() }
            ])
        spriteComp.node.run(action)
        
        print("Starship Destroyed from teams \(teams)")
    }
    
    
}

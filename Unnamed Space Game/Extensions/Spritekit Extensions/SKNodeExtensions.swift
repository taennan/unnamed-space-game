//
//  SKNodeExtensions.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 19/4/21.
//

import SpriteKit


//
extension SKNode {
    
    // Calls addChild() method and sets name for specified node
    func addChild(_ node: SKNode, withName name: String) {
        node.name = name
        self.addChild(node)
    }
    // Calls addChild() method for multiple nodes
    func addChildren(_ children: [SKNode]) {
        for node in children { self.addChild(node) }
    }
    
    // Allows placement within layers of scenes
    func setLayer(_ layer: UnSGScene.Layers) {
        self.zPosition = layer.rawValue
    }
    
    // Returns an array of all descendants of specified type
    func getDescendants<T>(ofType type: T.Type) -> [T] where T: SKNode {
        
        // The array to return
        var nodes: [T] = []
        
        // Iterates over children
        for child in children {
            // If the child is of specified type, appends to array and searches it's children
            if child is T { nodes.append(child as! T) }
            nodes += child.getDescendants(ofType: T.self)
        }
        
        return nodes
    }
    
    // Getter and Setter for the accumulated frame
    // - Useful for positioning the interactive entities in the displays
    func getAccFramePosition(ofSector sector: CGRect.Sector) -> CGPoint {
        return calculateAccumulatedFrame().getPosition(ofSector: sector)
    }
    func setAccFramePosition(anchorPoint: CGRect.Sector, position: CGPoint) {
        let absPos = +calculateAccumulatedFrame().getPosition(ofSector: anchorPoint)
        self.position = position + absPos
    }
    
    
}



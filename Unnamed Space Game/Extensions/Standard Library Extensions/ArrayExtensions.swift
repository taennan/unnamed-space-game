//
//  ArrayExtensions.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 19/4/21.
//

import SpriteKit

//
extension Array {
    
    // Returns the index at the end of the array
    func maxIndex() -> Int {
        let len = self.count    // <--- Calculated this so that 'self.count' doesn't have to be called twice
        let index = (len == 0) ? 0 : len - 1
        return index
    }
    
}

// Only affects arrays of type [SKNode]
extension Array where Element: SKNode {
    
    // Returns the node with the highest zPosition
    func getHigh() -> SKNode? {
        
        // The node with the highest zPosition is stored here and then returned
        var highest: SKNode? = nil
        // Iterates over items in self (if any...)
        for node in self {
            // Sets highest node if zPosition of the iterated node is greater than the current highest
            if let highNode = highest {
                if node.zPosition > highNode.zPosition { highest = node }
                
            } else {
                // This else block is only called at the beginning when there is no other node to compare against
                highest = node
            }
        }
        
        return highest
    }
    
    
}

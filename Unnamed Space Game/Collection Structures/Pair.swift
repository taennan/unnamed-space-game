//
//  Pair.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 6/7/21.
//

import Foundation

// Stores two values that can be accessed directly or by passing an index to it's methods
// - This was really just created to replace dictionaries holding the values from both teams
struct Pair<Element>: Sequence, IteratorProtocol {
    
    // So that different Teams can access values within self
    typealias Index = Team
    // Meant to be passed to modItems() method
    typealias ModifyingClosure = ((inout Element) -> Void)
    
    // The values stored
    var one: Element
    var two: Element
    
    // NOTE: Do not use this initialiser when using a pair of class objects
    //       Since classes are reference types, they get passed by reference to each value
    init(of val: Element) {
        if let obj = val as? NSCopying {
            self.one = obj as! Element
            self.two = obj.copy() as! Element
        } else {
            self.one = val
            self.two = val
        }
    }
    
    // Preferred initialiser for class types
    init(_ one: Element, _ two: Element) {
        self.one = one
        self.two = two
    }
    
    
    // ACCESSING
    // This method returns COPIES, not the actual instances
    func get(_ index: Index) -> Element {
        return (index == .one) ? self.one : self.two
    }
    
    // MODIFYING
    // Applies closures to specified value in self
    mutating func forElement(_ index: Index, modWith closure: ModifyingClosure) {
        (index == .one) ? { closure(&self.one) }() : { closure(&self.two)}()
    }
    // Passes both values contained in self to specified closure to apply commands
    mutating func forEach(_ closure: ModifyingClosure) {
        closure(&self.one)
        closure(&self.two)
    }
    
    // Does what it says
    mutating func equaliseElements(toValueFrom index: Index) {
        let newValue = (index == .one) ? self.one : self.two
        self.one = newValue
        self.two = newValue
    }
    
    // ITERATING
    private var iterCount: Int = 0 {
        // Loops count if past 2
        didSet { iterCount = (iterCount > 2) ? 0 : iterCount }
    }
    mutating func next() -> Element? {
        defer { iterCount += 1 }
        switch iterCount {
            case  0: return self.one
            case  1: return self.two
            default: return nil
        }
    }
    
    
}

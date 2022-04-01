//
//  Collection.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 26/6/21.
//


// This protocol is needed so that collections can
// recursively store references to other collections
protocol IsExclusive {
    
    var index: Int { get set }
    
}

// A sort of wrapper around the standard array type
// Is used when only a specific set of options are needed to be chosen from
// - Pretty much just created to store the colour options in the starship settings
// - Disallows two linked exclusive collections to have the same value at once
struct Collection<T>: IsExclusive where T: Equatable {
    
    //
    let defualtIndex: Int
    var index: Int {
        // Loops the index if it has gone out of bounds
        didSet {
            if index > elements.maxIndex() {
                index = 0
            } else if index < 0 {
                index = elements.maxIndex()
            }
        }
    }
    
    // The items stored
    let elements: [T]
    // Returns the element at the index
    var value: T { return elements[index] }
    // Returns an array of all elements, excluding the current element of any linked collection
    var activeElements: [T] {
        var elements = self.elements
        if let linked = linkedCollection as? Collection {
            for (i, e) in elements.enumerated() {
                if e == linked.value {
                    elements.remove(at: i)
                }
            }
        }
        return elements
    }
    
    // When set to another Collection, self cannot have the same value as the linked collection
    var linkedCollection: IsExclusive?
    var isExclusive: Bool {
        return (linkedCollection != nil) ? true : false
    }
    
    init(defualtIndex: Int = 0, contents: [T]) {
        guard contents.count > 1
            else { fatalError("Expected at least 2 elements in a Collection, got \(contents.count)") }
        
        self.defualtIndex     = defualtIndex
        self.index            = defualtIndex
        self.elements         = contents
    }
    
    // Sets self back to it's defualt value
    mutating func resetToDefualt() { self.index = defualtIndex }
    
    /*
    // An easy way to link two collections
    static func linkCollections(_ one: inout Collection, _ two: inout Collection) {
        one.setLinkedCollection(two)
        two.setLinkedCollection(one)
    }
    */
    
    // Sets the linked collection property
    mutating func setLinkedCollection(_ collection: Collection) {
        self.linkedCollection = collection
        // Modifies index to ensure that the current value is not the same as the linked collections'
        self.modIndex(increment: true)
    }
    mutating func mutuallyLink(_ collection: inout Collection) {
        self.setLinkedCollection(collection)
        collection.setLinkedCollection(self)
    }
    
    // Modifies the index if the current value equals the linked collections' value
    private mutating func modIndex(increment: Bool) {
        if index == linkedCollection?.index {
            let num = (increment) ? 1 : -1
            self.index += num
            modIndex(increment: increment)
        }
    }
    
    // Modifies index by specified amount and calls modIndex() to appropriately set value
    mutating func incrementIndex(by int: Int) {
        self.index += int
        
        let bool = (int > 0) ? true : false
        modIndex(increment: bool)
    }
    
    // When modifying the value of self with the incrementIndex() method
    // is unweildly, this method can be used to easily set the current value
    mutating func setIndex(toOption option: T, incrementWhenModifying bool: Bool = true) {
        if let index = elements.firstIndex(of: option) {
            self.index = index
            self.modIndex(increment: bool)
        } else {
            print("ERROR: No element of value \(option) is contained in Collection")
        }
    }
    
    
}

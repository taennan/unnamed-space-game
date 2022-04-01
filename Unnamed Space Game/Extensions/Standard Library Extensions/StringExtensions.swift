//
//  StringExtensions.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 30/6/21.
//

extension String {
    
    // Returns true if self can be converted to an Int else returns false
    // NOTE: This doesn't give expected results when called on string with underscores as digit seperation
    func isNum() -> Bool {
        if self.contains("_") {
            print("ERROR: isNum() method does not give expected results when called on String \(self) with underscores as digit seperation")
        }
        let bool = (Int(self) != nil) ? true : false
        return bool
    }
    
    
}

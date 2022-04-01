//
//  SKLabelNodeExtensions.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 19/4/21.
//

import SpriteKit


//
extension SKLabelNode {
    
    //
    enum SizeConstraint {
        case width(CGFloat)
        case height(CGFloat)
        case fontSize(CGFloat)
    }
    
    
    //
    convenience init(_ text: String, fontColour: NSColor = Colours.white, constraint: SizeConstraint) {
        self.init(text: text)
        self.fontColor = fontColour
        self.fontName = Fonts.ocr
        self.fontSize = 10      // <--- Have to assign font size before setting constraint
        self.applyConstraint(constraint)
    }
    
    
    //
    func applyConstraint(_ constraint: SizeConstraint) {
        
        switch constraint {
        case .width(let w):
            // Guards against dividing width parameter by zero
            guard self.frame.width != 0
                else { print("Cannot calculate size change. Frame width is zero"); return }
            
            // Calculates and sets new font size until it is within acceptable accuracy
            while self.frame.width > w * 1.05  || self.frame.width < w * 0.95 {
                let ratio = w / self.frame.width
                self.fontSize *= ratio
            }
            
        case .height(let h):
            // Guards against dividing height parameter by zero
            guard self.frame.height != 0
                else { print("Cannot calculate size change. Frame height is zero"); return }
            
            // Calculates and sets new font size until it is within acceptable accuracy
            while self.frame.height > h * 1.05  || self.frame.height < h * 0.95 {
                let ratio = h / self.frame.height
                self.fontSize *= ratio
            }
            
        case .fontSize(let s):
            self.fontSize = s
        }
        
    }
    
    
}

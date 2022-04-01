//
//  MenuRadioButton.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 4/6/21.
//

import SpriteKit

// Allows easy instantiation of navigation buttons for menus
// - NOTE: These objects are intended for use only by .north and .south displays
class MenuRadioButton: RadioButton {
    
    // These are multiplied with the size of the display they are
    // being added to to create uniform sizes across all displays
    static let buttonHeightRatio: CGFloat = 0.2
    static let buttonWidthRatio: CGFloat = 0.8
    
    static let buttonDividerRatio: CGFloat = 0.1
    static let buttonBorderRatio: CGFloat = 0.02
    
    init(_ labels: [String], displaySize: CGSize) {
        
        // Calculates size of self using the size of the display self is being added to
        let buttonSize = CGSize(width: displaySize.width * MenuRadioButton.buttonWidthRatio,
                                height: displaySize.height * MenuRadioButton.buttonHeightRatio)
        let dividerWidth = displaySize.height * MenuRadioButton.buttonDividerRatio
        
        /// Uncomment if needed
        /// let buttonBorderWidth = buttonSize.width * MenuRadioButton.buttonBorderRatio
        
        super.init(totalButtons: labels.count,
                   buttonSize: buttonSize,
                   arrangeHorizontally: false,
                   dividerWidth: dividerWidth,
                   backgroundTexture: nil)
        // Adds labels with constraints
        setButtonLabels(labels, constraint: .height(buttonSize.height * 0.7))
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
}

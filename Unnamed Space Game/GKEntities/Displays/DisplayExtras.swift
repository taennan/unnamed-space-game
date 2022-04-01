//
//  DisplayExtras.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 25/6/21.
//

import SpriteKit

// Used to differentiate the displays added to the scene
enum Pole: CaseIterable {
    case north
    case east
    case south
    case west
    
    //
    func opposite() -> Pole {
        switch self {
        case .north: return .south
        case .south: return .north
        case .west:  return .east
        case .east:  return .west
        }
    }
    
}

// Put these here so that entities wouldn't have to force unwrap the
// size of a Displays' background to determine sizes and positions
/// TODO: Figure out which computed properties can be deleted
extension Display {
    
    // Grabs the size of the views' frame
    private static var viewSize: CGSize       { return appDelegate.viewController.view.frame.size }
    
    // Border width
    static var spacing: CGFloat               { return Display.viewSize.height * 0.015 }
    
    // Height
    private static var eastHeight: CGFloat    { return viewSize.height * 0.15 }
    private static var cornerHeight: CGFloat  { return (viewSize.height - eastHeight - (spacing * 4)) / 2 }
    private static var westHeight: CGFloat    { return viewSize.height - (spacing * 2) }
    
    // Width
    private static var eastWidth: CGFloat     { return (viewSize.width * 0.3) - (spacing * 2) }
    private static var westWidth: CGFloat     { return viewSize.width - eastWidth - (spacing * 3) }
    
    // Positions
    private static var westX: CGFloat         { return (westWidth / 2) + spacing }
    private static var eastX: CGFloat         { return westWidth + (spacing * 2) + (eastWidth / 2) }
    private static var centerY: CGFloat       { return (westHeight / 2) + spacing }
    private static var northY: CGFloat        { return (cornerHeight * 1.5) + eastHeight + (spacing * 3) }
    private static var southY: CGFloat        { return cornerHeight / 2 + spacing }
    
    // Easy ways to get sizes and positions
    class func size(ofPole pole: Pole) -> CGSize {
        switch pole {
        case .west: return CGSize(width: westWidth, height: westHeight)
        case .east: return CGSize(width: eastWidth, height: eastHeight)
        default:    return CGSize(width: eastWidth, height: cornerHeight)
        }
    }
    class func position(ofPole pole: Pole) -> CGPoint {
        switch pole {
        case .north:
            return CGPoint(x: westWidth + (spacing * 2) + (eastWidth / 2),
                           y: (cornerHeight * 1.5) + eastHeight + (spacing * 3))
        case .east:
            return CGPoint(x: westWidth + (spacing * 2) + (eastWidth / 2),
                           y: (westHeight / 2) + spacing)
        case .south:
            return CGPoint(x: westWidth + (spacing * 2) + (eastWidth / 2),
                           y: cornerHeight / 2 + spacing)
        case .west:
            return CGPoint(x: (westWidth / 2) + spacing,
                           y: (westHeight / 2) + spacing)
        }
    }
    
    
}

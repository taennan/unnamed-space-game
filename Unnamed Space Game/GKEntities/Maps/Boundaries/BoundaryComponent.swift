//
//  BoundaryComponent.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 10/6/21.
//

import SpriteKit
import GameplayKit

//
class MapBoundaryComponent: GKComponent {
    
    var boundaries: [MapBoundary]
    
    init(withBoundaries: [MapBoundary]) {
        self.boundaries = withBoundaries
        super.init()
    }
    
    // These class methods are used to easily instantiate common boundary types
    
    // A single rectangular boundary
    class func euclidian(rect: CGRect, hp: Int = 0) -> MapBoundaryComponent {
        
        let path = CGMutablePath()
        path.addRect(rect)
        let bound = MapBoundary(.edge(hp), path: path)
        
        return MapBoundaryComponent(withBoundaries: [bound])
    }
    
    // Four boundaries looped to opposite sides
    class func toroidal(rect: CGRect) -> MapBoundaryComponent {
        
        let paths = MapBoundaryComponent.divideRect(rect)
        var bounds: [Pole: MapBoundary] = [:]
        
        for pole in Pole.allCases {
            bounds[pole] = MapBoundary(.looped(pole.opposite()), path: paths[pole]!)
        }
        
        return MapBoundaryComponent(withBoundaries: bounds.values.map { $0 })
    }
    
    // Four boundaries, two looped and two twisted
    class func mobius(rect: CGRect) -> MapBoundaryComponent {
        
        let paths = MapBoundaryComponent.divideRect(rect)
        var bounds: [Pole: MapBoundary] = [:]
        
        for pole in Pole.allCases {
            if pole == .east || pole == .west {
                bounds[pole] = MapBoundary(.twisted(pole.opposite()), path: paths[pole]!)
            } else {
                bounds[pole] = MapBoundary(.looped(pole.opposite()), path: paths[pole]!)
            }
            
        }
        
        return MapBoundaryComponent(withBoundaries: bounds.values.map { $0 })
    }
    
    // Called to easily set properties of all boundaries' shape nodes
    func setLines(colour: NSColor, width: CGFloat) {
        print("ALL BOUNDS: \(boundaries)")
        for bound in boundaries {
            print("ALL KIDS: \(bound.spriteComp.node.children)")
            if let shape = bound.spriteComp.node.childNode(withName: MapBoundary.boundaryKey) as? SKShapeNode {
                print("Set Colour")
                shape.strokeColor = colour
                shape.lineWidth = width
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // Creates and returns four paths from the sides of the rect specified
    private static func divideRect(_ rect: CGRect) -> [Pole: CGMutablePath] {
        
        // Gets the positions of the corners of the rect
        let nPoints = [CGPoint(x: rect.minX, y: rect.maxY), CGPoint(x: rect.maxX, y: rect.maxY)]
        let ePoints = [CGPoint(x: rect.minX, y: rect.maxY), CGPoint(x: rect.maxX, y: rect.maxY)]
        let sPoints = [CGPoint(x: rect.maxX, y: rect.minY), CGPoint(x: rect.minX, y: rect.minY)]
        let wPoints = [CGPoint(x: rect.minX, y: rect.minY), CGPoint(x: rect.minX, y: rect.maxY)]
        
        // Creates path to be returned from the points specified
        // NOTE: The order of the points in the array is important! Don't change it!
        var paths: [Pole: CGMutablePath] = [:]
        for (pole, points) in zip(Pole.allCases, [nPoints, ePoints, sPoints, wPoints]) {
            paths[pole] = (CGMutablePath().addLines(between: points) as! CGMutablePath)
        }
        
        return paths
    }
    
}

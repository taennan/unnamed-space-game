//
//  FieldComponent.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 3/1/21.
//

import GameplayKit
import SpriteKit

//
class FieldComponent: GKComponent {
    
    // All fields are added to this node
    let node = SKNode()
    
    //
    enum FieldType {
        case gravity
        case magnetic
        case drag
    }
    
    // The keys used to access nodes
    static func fieldKey(forField fieldType: FieldType) -> String {
        switch fieldType {
        case .gravity:  return "gravfield"
        case .drag:     return "dragfield"
        case .magnetic: return "magfield"
        }
    }
    static func spriteKey(forField fieldType: FieldType) -> String {
        return fieldKey(forField: fieldType) + "sprite"
    }
    static let backgroundDragSpriteKey: String = "background" + spriteKey(forField: .drag)
    
    //
    private func defualtTexture(forField field: FieldType) -> SKTexture {
        switch field {
        case .gravity:  return SKTexture.circle(.green, .none)
        case .drag:     return SKTexture.circle(.red, .none)
        case .magnetic: return SKTexture.circle(.teal, .none)
        }
    }
    
    // Adds a circular field with specified properties
    // - The 'hasSpriteWithCustomTexture' parameter is used to determine if a sprite should be created to be able to visualise the fields region
    // - If the 'SKTexture?' field of the tuple is left as nil and the 'Bool' field is true, a defualt texture will be used
    func addField(_ fieldType: FieldType,
                  radius: CGFloat, strength: Float, falloff: Float,
                  hasSpriteWithCustomTexture: (Bool, SKTexture?) = (true, nil)) {
        
        // Creates appropriate field subtype
        let field: SKFieldNode
        switch fieldType {
        case .gravity:  field = SKFieldNode.radialGravityField()
        case .drag:     field = SKFieldNode.dragField()
        case .magnetic: field = SKFieldNode.magneticField()
        }
        // Sets properties and adds to node
        field.region = SKRegion(radius: Float(radius))
        field.strength      = strength
        field.falloff       = falloff
        field.isEnabled     = true
        field.isExclusive   = false
        node.addChild(field, withName: FieldComponent.fieldKey(forField: fieldType))
        
        
        // If specified, creates a sprite to serve as the visual part of the field
        // - Deconstructs 'hasSpriteWithCustomTexture' tuple to make it easier to work with
        let (hasSprite, customTexture) = hasSpriteWithCustomTexture
        if hasSprite {
            // Creates sprite
            let sprite = SKSpriteNode()
            sprite.size  = CGSize(squareOfWidth: radius * 2)
            sprite.alpha = 0.2
            // If a custom texture is specified, the defualts will not be used
            let texture = (customTexture != nil) ? customTexture! : defualtTexture(forField: fieldType)
            sprite.texture = texture
            // Adds to node
            node.addChild(sprite, withName: FieldComponent.spriteKey(forField: fieldType))
            
            // Sets layer depending on field type
            switch fieldType {
            case .gravity:
                sprite.setLayer(.gravityField)
            case .magnetic:
                sprite.setLayer(.magneticField)
            case .drag:
                sprite.setLayer(.atmosphereForeground)
                
                // As drag fields need a background a copy of the first sprite is made for this purpose
                // - The alpha value is set higher than the foreground
                let bgSprite = sprite.copy() as! SKSpriteNode
                bgSprite.alpha = 0.6
                node.addChild(bgSprite, withName: FieldComponent.backgroundDragSpriteKey)
            }
        }
        
    }
    
}

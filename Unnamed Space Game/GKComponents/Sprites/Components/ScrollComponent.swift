//
//  ScrollComponent.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 12/2/21.
//

import GameplayKit
import SpriteKit


//
class ScrollComponent: GKComponent {
    
    // The interactive sprite which acts as a background to the scrollbar
    let bar: ScrollBar
    static let barKey: String = "scrollbar"
    
    
    // A sprite which shows where along the mask node the user has scrolled to
    var scroller: SKSpriteNode?
    static let scrollerKey: String = "scroller"
    //
    private var scrollerRatio: CGFloat
    
    
    // The node which will have its y position modified by the scrolling action
    var scrolledNode: SKNode? = nil
    
    
    // Whether the scrolling area starts at the top or bottom
    let startsHigh: Bool
    
    // A multiplier to increase or decrease distance scrolled
    var stiffening: CGFloat = 1
    
    
    init(barSize: CGSize,
         // Preset argument
         scrollerStartsHigh: Bool = true) {
        
        self.startsHigh     = scrollerStartsHigh
        self.scrollerRatio  = 0
        
        // Creates a button for the scrollbar
        bar = ScrollBar(size: barSize, handlesMouseEvents: [.mouseDown], borderWidth: 0)
        bar.spriteComp.body?.setLayer(.dropdownBody)
        bar.multiplePressesEnabled = true
        
        super.init()
        
        // Sets command of scrollbar
        bar.setCommand { self.jump() }
        
    }
    
    
    // Creates a scroller sprite and calculates scrolling ratio for it and the scrolled node
    // - This method must be called after a crop component has been added to the entity
    func setScrolledNode(_ node: SKNode) {
        
        // Sets scrolled node
        self.scrolledNode = node
        
        // Checks if there is a mask node as the positions and sizes of the sprites are calculated off it
        guard let mask = entity?.component(ofType: CropComponent.self)?.cropNode.maskNode,
              let bar  = bar.spriteComp.body
            else { print("No mask node to calculate positions with in ScrollComponent() object"); return }
        
        // The accumulated frame of the scrolled node
        let nodeAccFrame: CGRect = scrolledNode!.calculateAccumulatedFrame()
        // Calculates ratio between mask and scrolled node frames
        self.scrollerRatio = mask.frame.height / nodeAccFrame.height
        
        
        // Creates a scroller sprite
        scroller = SKSpriteNode()
        scroller?.texture = SKTexture.square(.grey)
        scroller?.size = CGSize(width: bar.size.width * 0.75,
                                height: bar.size.height * scrollerRatio)
        scroller?.setLayer(.dropdownInfo)
        bar.addChild(scroller!, withName: ScrollComponent.scrollerKey)
        
        // Sets positions of scrolled node and scroller
        if self.startsHigh {
            scrolledNode?.position.y = mask.frame.maxY - nodeAccFrame.maxY
            scroller?.position.y     = bar.frame.maxY - scroller!.frame.maxY
        } else {
            scrolledNode?.position.y = mask.frame.minY - nodeAccFrame.minY
            scroller?.position.y     = bar.frame.minY - scroller!.frame.minY
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // Keeps scroller and scrolled node within mask
    private func modPositions() {
        //Checks if all the necessary nodes are present
        guard let scrolledNode = scrolledNode,
              let scroller     = scroller,
              let mask         = entity?.component(ofType: CropComponent.self)?.cropNode.maskNode,
              let barBody      = bar.spriteComp.body
            else { print("No scroller, scrolled node or mask node property in ScrollComponent() object"); return }
        
        // The accumulated frame of the scrolled node and it's descendants
        let accFrame: CGRect = scrolledNode.calculateAccumulatedFrame()
        
        // Checks if the scrolled node has been moved out of bounds and resets position
        if accFrame.maxY < mask.frame.maxY {
            // Decreases position of the scrolled node and scroller
            scrolledNode.position.y = mask.frame.maxY - accFrame.size.height / 2
            scroller.position.y     = barBody.frame.maxY - scroller.size.height / 2
            
        } else if accFrame.minY > mask.frame.minY {
            // Increases position of scrolled node and scroller
            scrolledNode.position.y = mask.frame.minY + accFrame.size.height / 2
            scroller.position.y     = barBody.frame.minY + scroller.size.height / 2
        }
        
    }
    
    
    // Called to scroll with scroll wheel event
    func scroll(by deltaY: CGFloat) {
        
        // Increases or decreases y position
        scrolledNode?.position.y += deltaY * stiffening
        scroller?.position.y -= (deltaY * stiffening) * scrollerRatio
        
        // Keeps nodes within bounds
        modPositions()
    }
    
    // Called to scroll with mouse down event on the scroll bar
    func jump() {
        //Checks if all the necessary nodes are present
        guard let scrolledNode = scrolledNode
            else { print("No scrolled node for jump() method") ;return }
        guard let scroller = scroller
            else { print("No scroller for jump() method") ;return }
        guard let barBody = bar.spriteComp.body
            else { print("No bar body for jump() method"); return }
        guard let scene = barBody.scene as? UnSGScene
            else { print("No scene for jump() method"); return }
        
        // Gets mouse position
        let mousePos = barBody.convert(scene.getMousePositionFromWindow(), from: scene)
        
        // Checks if the converted point is contained within the scrollbar
        if barBody.contains(mousePos) {
            
            // Calculates values to modify position of scrolled node by
            let ratio = 1 / scrollerRatio
            let difference = scroller.position.y - mousePos.y
            
            // Sets position of scrolled node
            //- The position of the scrolled node is modified with the '+=" operator as the 'difference' value will be negative when appropriate
            if mousePos.y > scroller.position.y {
                scrolledNode.position.y += difference * ratio
            } else {
                scrolledNode.position.y += difference * ratio
            }
            
            // Sets position of scroller
            scroller.position.y = mousePos.y
            
            // Keeps nodes within bounds
            modPositions()
        }
        
    }
    
    
}

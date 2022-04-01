//
//  ScrollDisplay.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 30/5/21.
//

import SpriteKit


//
class ScrollDisplay: CropDisplay, RespondsToScrollEvents {
    
    private let scrollComp: ScrollComponent
    
    private let scrollBG: InteractiveSprite
    private let scrolledNode = SKNode()
    
    override var rootNode: SKNode { return scrolledNode }
    
    init(_ pole: Pole, scrollBarWidthMultiplier: CGFloat) {
        
        let size    = Display.size(ofPole: pole)
        let barSize = CGSize(width: size.width * scrollBarWidthMultiplier, height: size.height)
        let bgSize  = CGSize(width: size.width - barSize.width, height: size.height)
        
        self.scrollComp = ScrollComponent(barSize: barSize)
        self.scrollBG   = InteractiveSprite(texture: SKTexture(), size: bgSize)
        
        super.init(pole)
        addComponent(scrollComp)
        
        cropComp.cropNode.maskNode = SKSpriteNode()
        cropComp.maskNode?.size = bgSize
        cropComp.cropNode.addChild(scrolledNode)
        
        scrollBG.size   = cropComp.maskNode!.size
        scrollBG.entity = self
        scrollBG.setEventsHandled([.scrollWheel])
        scrollBG.setLayer(.dropdownBase)
        spriteComp.node.addChild(scrollBG)
        
        scrollComp.bar.spriteComp.base?.size = barSize
        scrollComp.bar.spriteComp.node.position.x = (size.width / 2) - (barSize.width / 2)
        scrollComp.setScrolledNode(scrolledNode)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    //
    func scrollWheel(by deltaY: CGFloat) {
        scrollComp.scroll(by: deltaY)
    }
    
    
}

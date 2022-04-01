//
//  ViewController.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 7/12/20.
//

import SpriteKit
import GameplayKit


class ViewController: NSViewController {
    
    // The view
    let skView: SKView = UnSGView()
    
    // Sets up view
    override func loadView() {
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        skView.showsFields = true
        skView.showsDrawCount = true
        view = skView
    }
    
    // Presents the first scene of the game
    override func viewDidLoad() {
        super.viewDidLoad()
        skView.presentScene(StartupScene())
        skView.scene?.scaleMode = .aspectFill
    }
    
    // Calls scrollWheel() in skScene as scenes are not part of the scrolling responder chain
    override func scrollWheel(with event: NSEvent) {
        skView.scene?.scrollWheel(with: event)
    }
    
}

// Created for testing, delete later
class UnSGView: SKView {}

//
//  AppDelegate.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 7/12/20.
//

import Cocoa


class AppDelegate: NSObject, NSApplicationDelegate {
    
    // The name of the game
    static let projectName: String = "Unnamed Space Game"
    
    // Used by Dsiplay() entities to correctly determine their height
    var appFinishedLaunching: Bool = false

    // The screen displaying the window
    let screen: NSScreen? = NSScreen.main
    // The window
    var window: NSWindow?
    // The view controller
    let viewController = ViewController()
    
    
    override init() {
        super.init()
        print("\(AppDelegate.projectName) opened \n")
    }
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let screenWidth: CGFloat = screen?.frame.width ?? 2560
        let screenHeight: CGFloat = screen?.frame.height ?? 1440
        
        // Window's size via it's ViewController. Only the width property really matters as it's aspect ratio will ignore height
        let windowWidth: CGFloat = screenWidth / 3
        let windowHeight: CGFloat = screenHeight / 3
        
        // Instantiates the window
        window = NSWindow(contentRect: NSMakeRect(0, 0, windowWidth, windowHeight),
                          styleMask: [.miniaturizable, .closable, .resizable, .titled],
                          backing: .buffered,
                          defer: false)
        // Sets aspect ratio and title
        window?.aspectRatio = NSSize(width: screenWidth, height: screenHeight)
        window?.title = AppDelegate.projectName
        // Brings window to front of screen
        window?.makeKeyAndOrderFront(nil)
        
        appFinishedLaunching = true
        
        // Sets up view controller
        viewController.skView.setFrameSize(NSSize(width: windowWidth, height: windowHeight))
        window?.contentViewController = viewController
        
        // Messages to debugger
        print("Screen size: \(screenWidth), \(screenHeight)")
        print("Window size: \(window!.frame.size))")
        print("View size: \(viewController.view.frame.size)")
        print("Scene size: \(viewController.skView.scene?.size ?? CGSize(width: 0, height: 0))")
        print("Tracking Area rect: \(viewController.view.trackingAreas.first?.rect as Any)\n")
    }
    
    
    // Terminates app if all of it's windows are closed
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { return true }
    
    // Runs just before app terminates
    func applicationWillTerminate(_ aNotification: Notification) { print("\n\(AppDelegate.projectName) terminated") }

    
}

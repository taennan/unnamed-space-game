//
//  main.swift
//  Unnamed Space Game
//
//  Created by Taennan Rickman on 7/12/20.
//

import Cocoa


// This stuff initialises the app and runs. This file must have a lowercase name
let appDelegate = AppDelegate()
NSApplication.shared.delegate = appDelegate

let loop = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)

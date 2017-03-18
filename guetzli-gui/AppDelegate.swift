//
//  AppDelegate.swift
//  guetzli-gui
//
//  Created by Matthew Davies on 3/17/17.
//  Copyright © 2017 Matthew Davies. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var preferencesWindow : PreferencesWindowController!

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

  @IBAction func preferencesClicked(_ sender: NSMenuItem) {
    preferencesWindow = PreferencesWindowController(windowNibName: "PreferencesWindowController")
    preferencesWindow.showWindow(nil)
  }

}

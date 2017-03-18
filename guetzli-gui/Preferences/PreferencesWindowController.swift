//
//  PreferencesWindowController.swift
//  guetzli-gui
//
//  Created by Matthew Davies on 3/17/17.
//  Copyright © 2017 Matthew Davies. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController, NSTextFieldDelegate {

  @IBOutlet weak var binPath: NSTextField!
  @IBOutlet weak var pathError: NSTextField!

  override func windowDidLoad() {
    super.windowDidLoad()

    binPath.stringValue = UserDefaults.standard.string(forKey: "binPath") ?? ""
  }

  func setBinPath(path: String?) {
    if let path = path {
      UserDefaults.standard.set(URL(fileURLWithPath: path), forKey: "binPath")
    } else {
      UserDefaults.standard.set(nil, forKey: "binPath")
    }
  }

  override func controlTextDidChange(_ obj: Notification) {
    if binPath.stringValue.characters.count > 0 {
      let (result, error) = Command.exec("ls", binPath.stringValue)

      let resultArray = result.components(separatedBy: .newlines)

      if error || resultArray.count > 2 || URL(fileURLWithPath: resultArray[0]).lastPathComponent != "guetzli" {
        pathError.isHidden = false
      } else {
        pathError.isHidden = true
        self.setBinPath(path: binPath.stringValue)
      }

    } else {
      self.setBinPath(path: nil)
    }
  }

  @IBAction func findDefault(_ sender: AnyObject) {
    let (result, error) = Command.exec("which", "guetzli")
    let trimmedResult = result.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    if error != true {
      self.setBinPath(path: trimmedResult)
      self.binPath.stringValue = trimmedResult
    }
  }
}

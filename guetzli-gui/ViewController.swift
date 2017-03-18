//
//  ViewController.swift
//  guetzli-gui
//
//  Created by Matthew Davies on 3/17/17.
//  Copyright © 2017 Matthew Davies. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

  @IBOutlet weak var inFileUrlField: NSTextField!
  @IBOutlet weak var outFileUrlField: NSTextField!
  @IBOutlet weak var qualityField: NSTextField!
  @IBOutlet weak var progressIndicator: NSProgressIndicator!
  @IBOutlet weak var compressButton: NSButton!

  var inFile : URL?
  var outFile : URL?
  var quality = 85

  override func viewDidLoad() {
    super.viewDidLoad()

    qualityField.integerValue = quality

    // Do any additional setup after loading the view.
  }

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }

  @IBAction func onOpenFile(_ sender: AnyObject) {
    let openPanel = NSOpenPanel()

    openPanel.begin { (result) in
      if (result == NSFileHandlingPanelOKButton) {
        self.inFile = openPanel.urls[0]
        self.inFileUrlField.stringValue = openPanel.urls[0].path
      }
    }
  }

  @IBAction func onSaveFile(_ sender: AnyObject) {
    let savePanel = NSSavePanel()

    if let inFile = self.inFile {
      savePanel.directoryURL = inFile.baseURL
      savePanel.nameFieldStringValue = inFile.lastPathComponent
    }

    savePanel.begin { (result) in
      if (result == NSFileHandlingPanelOKButton) {
        guard let url = savePanel.url else {
          return
        }
        self.outFile = url
        self.outFileUrlField.stringValue = url.path
      }
    }
  }

  @IBAction func qualityDidChange(_ sender: NSTextField) {
    if sender.integerValue < 84 {
      sender.integerValue = 84
    }
  }

  @IBAction func stepperDidChange(_ sender: NSStepper) {
    qualityField.integerValue = sender.integerValue
  }

  @IBAction func compress(_ sender: NSButton) {
    let binUrl = URL(fileURLWithPath: UserDefaults.standard.string(forKey: "binPath") ?? "/usr/local/bin/guetzli")

    guard let inFilePath = inFile?.path else {
      return
    }

    guard let outFilePath = outFile?.path else {
      return
    }

    qualityField.isEnabled = false
    progressIndicator.isHidden = false
    progressIndicator.startAnimation(nil)
    compressButton.isEnabled = false
    compressButton.title = "Compressing..."

    Command.execAsync(terminationHandler: { (task) in
      DispatchQueue.main.async(execute: {
        self.progressIndicator.isHidden = true
        self.progressIndicator.stopAnimation(nil)
        self.compressButton.isEnabled = true
        self.compressButton.title = "Compress"

        self.qualityField.isEnabled = true
      })
    },
    binUrl.path, "--quality", "\(quality)", inFilePath, outFilePath)
  }

}


//
//  Command.swift
//  guetzli-gui
//
//  Created by Matthew Davies on 3/17/17.
//  Copyright © 2017 Matthew Davies. All rights reserved.
//

import Foundation

class Command {

  static func exec (_ args: String...) -> (String, Bool) {
    let task = Process()
    task.launchPath = ProcessInfo().environment["SHELL"]
    task.arguments = ["-l", "-c", "\(args.joined(separator: " "))"]

    let outPipe = Pipe()
    task.standardOutput = outPipe

    task.launch()
    task.waitUntilExit()

    let error = task.terminationStatus == 0 ? false : true

    return (NSString(data: outPipe.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8.rawValue)! as String, error)
  }

  static func execAsync(terminationHandler: ((Process) -> Void)?, _ args: String...) -> Void {
    let task = Process()
    task.launchPath = ProcessInfo().environment["SHELL"]
    task.arguments = ["-l", "-c", "\(args.joined(separator: " "))"]

    if let handler = terminationHandler {
      task.terminationHandler = handler
    }

    task.launch()
  }

}

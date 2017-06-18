//
//  AppDelegate.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/16/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let parsingTableFileName = "parsingTable.json"

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        let docURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(parsingTableFileName)
        
        if !FileManager().fileExists(atPath: docURL.path) {
            let path = Bundle.main.path(forResource: "language", ofType: "plist")!
            let dict = NSDictionary(contentsOfFile: path) as! [String: [[String]]]
            let generator = ParsingTableGenerator(dict: dict)
            generator.work()
            if let data = try? JSONSerialization.data(withJSONObject: generator.result.json, options: .prettyPrinted) {
                try? data.write(to: docURL, options: .atomic)
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}


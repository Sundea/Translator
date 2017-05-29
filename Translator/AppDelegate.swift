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



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
//        var table = ParsingTable()
//        
//        let t = Identifier("gf", TextPoint(line: 1, character: 12))
//        table[t, t] = .lessThan
//        print(table.description)
//        
//        
//        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("test.json")
//        
//        if let data = try? JSONSerialization.data(withJSONObject: table.json, options: .prettyPrinted) {
//            print(fileURL)
//            try? data.write(to: fileURL, options: .atomic)
//        }
//        
//        if let readData = try? Data.init(contentsOf: fileURL) {
//        
//            let dict = try! JSONSerialization.jsonObject(with: readData) as! [String: Any]
//            if let tav = ParsingTable(json: dict) {
//                print(tav)
//            }
//            
//        }

        if let path = Bundle.main.path(forResource: "language", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: [[String]]] {
            let generator = ParsingTableGenerator(dict: dict)
            generator.work()
            for (left, rule) in generator.result.dictionary {
                for (right, relation) in rule {
                    print("\(left)    \(relation.rawValue)    \(right)")
                }
            }
            
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("test.json")
    
            if let data = try? JSONSerialization.data(withJSONObject: generator.result.json, options: .prettyPrinted) {
                print(fileURL)
                try? data.write(to: fileURL, options: .atomic)
            }
            
            for (key, value) in dict {
                for subrule in value {
                    var sd = "\(key) ::="
                    
                    for token in subrule {
                        sd.append(" " + token)
                    }
                    print(sd)
                }
            }
        }
        
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}


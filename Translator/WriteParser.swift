//
//  WriteParser.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/29/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation
import Cocoa

extension Notification.Name {
    static let writeToConsole = Notification.Name("Write-To-Console")
    static let readFromConsole = Notification.Name("Read-From-Console")
}

class WriteParser: ReversePolishNotationParser {
    
    override func generateReversePolishNotation() {
        
    }
    
    override func evaluate() {
        
        var tokens = [Token]()
        while let element = input.dequeue(), element.lexeme != OperatorPool.closeParenthesis {
            if let constant = element.lexeme as? ValueStorable {
                if constant.value != nil {
                    tokens.append(element)
                } else {
                    tokens = [element]
                    break
                }
            }
        }
        if !tokens.isEmpty {
            let dict = ["tokens": tokens]
            NotificationCenter.default.post(name: .writeToConsole, object: self, userInfo: dict)
        }
    }
}

class ReadParser: ReversePolishNotationParser {
    override func evaluate() {
        var tokens = [Token]()
        while let element = input.dequeue(), element.lexeme != OperatorPool.closeParenthesis {
            if let _ = element.lexeme as? ValueAccesible {
                    tokens.append(element)
            }
        }
        
        if !tokens.isEmpty {
            let window = NSApplication.shared().mainWindow
            let viewController = window?.contentViewController as! ViewController
            let input = viewController.readVariable()
            let nums = input.components(separatedBy: CharacterSet.whitespaces)
            var iterator = nums.makeIterator()
            for token in tokens {
                (token.lexeme as! ValueAccesible).set(Int(iterator.next()!)!)
            }
            
            let dict = ["tokens": tokens]
            NotificationCenter.default.post(name: .readFromConsole, object: self, userInfo: dict)
        }
    }
}

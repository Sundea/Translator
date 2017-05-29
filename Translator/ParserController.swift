//
//  ParserController.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/29/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class ParserController: ReversePolishNotationParser {
    
    override func parse() {
        while let _ = input.front {
            let subparser = self.subparser()
            if let parser = subparser {
                parser.parse()
                self.input = parser.input
                append(parser.snapshots)
            } else {
                let _ = input.dequeue()
            }
        }
    }
}

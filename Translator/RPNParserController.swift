//
//  RPNParserController.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/30/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class RPNParserController: RPNParser {
    
    override func parse() -> Bool {
        WorkLabel.setIndexToZero()
        Label.setIndexToZero()
        snapshot()
        repeat {
            if let nestedParser = RPNParser.parser(for: &input) {
                nestedParser.parse()
                merge(nestedParser)
            } else {
                let _ = input.dequeue()
            }
        } while input.front != nil
        
        return evaluate()
//        return true
    }
    
    func evaluate() -> Bool {
        let evaluator = RPNEvaluator(output)
        return evaluator.evaluate()
    }
}

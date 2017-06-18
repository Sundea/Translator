//
//  RPNExpressionParser.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/29/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class RPNExpressionParser: RPNParser {
    
    var tokens: [Token]
    
    override init(_ input: inout Queue<Token>) {
        self.tokens = input.array
        super.init(&input)
    }
    
    
    override func replace(_ operation: SimplePolishOperator, at position: TextPoint) -> SimplePolishOperator {
        var result = operation
        
        if operation === OperatorPool.minus, let token = tokens.first(where: { $0.position == position }) {
            if let index = tokens.index(of: token) {
                let previndex = tokens.index(before: index)
                let prev = tokens[previndex]
                if prev.lexeme == OperatorPool.assignValue || prev.lexeme == OperatorPool.openParenthesis {
                    result = OperatorPool.unaryMinus
                }
            }
        }
        
        return result
    }
    
    override func customAppend(_ operation: SimplePolishOperator) -> Bool {
        if operation === OperatorPool.closeParenthesis {
            while let pop = magazine.pop(), pop != OperatorPool.openParenthesis {
                output.append(pop)
            }
            return true
        }
        return false
    }
}

//
//  RPNExpressionParser.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/29/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class RPNExpressionParser: RPNParser {
    
    override func replace(_ operation: SimplePolishOperator, at position: TextPoint) -> SimplePolishOperator {
        var result = operation
        
        if operation === OperatorPool.minus, let top = magazine.top, top == OperatorPool.assignValue {
            result = OperatorPool.unaryMinus
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

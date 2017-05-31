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
    
    override func tempTranslate() {
        evaluate()
    }
    
    func evaluate() {
        var magazine = Stack<ReversePolishElement>()
        var expression = Queue<ReversePolishElement>(output)
        
        while var element = expression.dequeue() {
            if let operation = element as? SimplePolishOperator {
                if operation === OperatorPool.unaryMinus {
                    var value = magazine.pop() as! ValueStorable
                    value = Constant(-value.value)
                    element = value as! ReversePolishElement
                } else {
                    let right = magazine.pop() as! ValueStorable
                    var left = magazine.pop() as! ValueStorable
                    
                    switch operation {
                    case OperatorPool.minus:
                        left = Constant(left.value - right.value)
                    case OperatorPool.plus:
                        left = Constant(left.value + right.value)
                    case OperatorPool.multiply:
                        left = Constant(left.value * right.value)
                    case OperatorPool.divide:
                        left = Constant(left.value / right.value)
                    case OperatorPool.power:
                        left = Constant(Int(pow(Double(left.value), Double(right.value))))
                    case OperatorPool.assignValue:
                        (left as! Identifier).set(right.value)
                    default:
                        break
                    }
                    
                    element = left as! ReversePolishElement
                }
        }
        magazine.push(element)
    }
        print("\((magazine.pop() as! ValueStorable).value)")
    }
    
}

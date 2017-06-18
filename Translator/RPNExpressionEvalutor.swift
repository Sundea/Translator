//
//  RPNExpressionEvalutor.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 6/5/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class RPNExpressionEvaluator: RPNEvaluator {
    
    override func evaluate() -> Bool {
        for var rpnElement in input {
            if let operation = rpnElement as? SimplePolishOperator {
                if operation === OperatorPool.unaryMinus {
                    var value = magazine.pop() as! ValueStorable
                    value = Constant(-value.value)
                    rpnElement = value as! ReversePolishElement
                } else {
                    let right = magazine.pop() as! ValueStorable
                    var left = magazine.pop() as! ValueStorable
                    
                    if let rightValue = right.value {
                        
                        switch operation {
                        case OperatorPool.minus:
                            left = Constant(left.value - rightValue)
                        case OperatorPool.plus:
                            left = Constant(left.value + rightValue)
                        case OperatorPool.multiply:
                            left = Constant(left.value * rightValue)
                        case OperatorPool.divide:
                            if rightValue != 0 {
                                left = Constant(left.value / rightValue)
                            } else {
                                return false
                            }
                        case OperatorPool.power:
                            left = Constant(Int(pow(Double(left.value), Double(rightValue))))
                        case OperatorPool.assignValue:
                            (left as! Identifier).set(rightValue)
                        default:
                            break
                        }
                        
                        rpnElement = left as! ReversePolishElement
                    } else {
                        return false
                    }
                }
            }
            magazine.push(rpnElement)
        }
        return true
    }
}

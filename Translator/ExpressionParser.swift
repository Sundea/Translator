//
//  ExpressionParser.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/24/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

struct ExpressionParserSnapshot {
    let inputStream: String
    let stack: String
    let reversePolish: String
    
    
    init(_ inputStream: String,_ stack: String,_ reversePolish: String) {
        self.inputStream = inputStream
        self.stack = stack
        self.reversePolish = reversePolish
    }
}

class ExpressionParser: ReversePolishNotationParser {
    
    
    override func generateReversePolishNotation()  {
        
        makeSnapshot()
        var prev: Token!
        while let token = input.dequeue(), token.lexeme != OperatorPool.newLine {
            
            if token.lexeme is ValueStorable, let value = token.lexeme as? ReversePolishNotation {
                output.append(value)
                makeSnapshot()
            } else if var currentOperation = token.lexeme as? SimplePolishOperator {
                if currentOperation === OperatorPool.minus && prev.lexeme is Terminal {
                    currentOperation = OperatorPool.unaryMinus
                }
                if magazine.isEmpty {
                    magazine.push(currentOperation)
                    makeSnapshot()
                } else if token.lexeme == OperatorPool.closeParenthesis {
                    while let pop = magazine.pop(), pop != OperatorPool.openParenthesis {
                        output.append(pop)
                    }
                } else {
                    while let previousOperation = magazine.top {
                        if previousOperation.stackPriority >= currentOperation.comparePriority {
                            let _ = magazine.pop()
                            output.append(previousOperation)
                            continue
                        } else {
                            magazine.push(currentOperation)
                            break
                        }
                    }
                }
            }
            prev = token
        }
        
        while let pop = magazine.pop() {
            output.append(pop)
            makeSnapshot()
        }
    }

    
    
    override func evaluate() {
        var magazine = Stack<ReversePolishNotation>()
        var expression = Queue<ReversePolishNotation>(output)
        
        while var element = expression.dequeue() {
            if let operation = element as? SimplePolishOperator {
                if operation === OperatorPool.unaryMinus {
                    var value = magazine.pop() as! ValueStorable
                    value = Constant(-value.value)
                    element = value as! ReversePolishNotation
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
                    
                    element = left as! ReversePolishNotation
                }
            }
            magazine.push(element)
        }
        
        print("\((magazine.pop() as! ValueStorable).value)")
    }
}

//
//  PRNEvaluator.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 6/5/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation
import Cocoa

extension Notification.Name {
    static let runtimeMistake = Notification.Name("Runtime mistake")
}

class RPNEvaluator  {
    
    let input: [ReversePolishElement]
    lazy var magazine = Stack<ReversePolishElement>()
    var iterator: IndexingIterator<[ReversePolishElement]>!
    
    init(_ input: [ReversePolishElement]) {
        self.input = input
    }
    
    
    func evaluate() -> Bool {
        self.iterator = input.makeIterator()
        var magazineElement: ReversePolishElement?
        
        while let rpnElement = iterator.next() {
            magazineElement = rpnElement
            if let operation = rpnElement as? SimplePolishOperator {
                
                if operation === OperatorPool.write {
                    let value = magazine.pop() as! ValueStorable
                    write(value)
                } else if operation === OperatorPool.read {
                    let value = magazine.pop() as! ValueAccesible
                    read(value)
                } else if operation === OperatorPool.unaryMinus {
                    var value = magazine.pop() as! ValueStorable
                    value = Constant(-value.value)
                    magazineElement = value as? ReversePolishElement
                } else if operation === OperatorPool.not {
                    
                    var value = magazine.pop() as! ValueStorable
                    value = Constant(value.value > 0 ? 0 : 1)
                    magazineElement = value as? ReversePolishElement
                } else {
                    let right = magazine.pop() as! ValueStorable
                    var left = magazine.pop() as! ValueStorable
                    
                    if let rightValue = right.value {
                        
                        if operation != OperatorPool.assignValue {
                            if let leftValue = left.value {
                                switch operation {
                                case OperatorPool.moreThan:
                                    left = Constant(Int(leftValue > rightValue ? 1 : 0))
                                case OperatorPool.moreOrEqualThan:
                                    left = Constant(Int(leftValue >= rightValue ? 1 : 0))
                                case OperatorPool.lessThen:
                                    left = Constant(Int(leftValue < rightValue ? 1 : 0))
                                case OperatorPool.lessOrEqualThan:
                                    left = Constant(Int(leftValue <= rightValue ? 1 : 0))
                                case OperatorPool.equal:
                                    left = Constant(Int(leftValue == rightValue ? 1 : 0))
                                case OperatorPool.notEqual:
                                    left = Constant(Int(leftValue != rightValue ? 1 : 0))
                                case OperatorPool.and:
                                    left = Constant(Int((leftValue > 0 && rightValue > 0) ? 1 : 0))
                                case OperatorPool.or:
                                    left = Constant(Int((leftValue > 0 || rightValue > 0) ? 1 : 0))
                                case OperatorPool.minus:
                                    left = Constant(leftValue - rightValue)
                                case OperatorPool.plus:
                                    left = Constant(leftValue + rightValue)
                                case OperatorPool.multiply:
                                    left = Constant(leftValue * rightValue)
                                case OperatorPool.divide:
                                    if rightValue != 0 {
                                        left = Constant(leftValue / rightValue)
                                    } else {
                                        let mistake = RuntimeMistake("`\((left as! Lexeme).representation) / \((right as! Lexeme).representation)` divider by 0")
                                        send(mistake)
                                        return false
                                    }
                                case OperatorPool.power:
                                    left = Constant(Int(pow(Double(leftValue), Double(rightValue))))
                                default:
                                    break
                                }
                            } else {
                                let mistake = RuntimeMistake("`\((left as! Lexeme).representation) / \((right as! Lexeme).representation)` \((left as! Lexeme).representation) not initilized yet")
                                send(mistake)
                                return false
                            }
                            magazineElement = left as? ReversePolishElement
                        } else {
                            (left as! Identifier).set(rightValue)
                        }
                    } else {
                        let mistake = RuntimeMistake("`\((left as! Lexeme).representation) / \((right as! Lexeme).representation)` \((right as! Lexeme).representation) not initilized yet")
                        send(mistake)
                        return false
                    }
                }
            } else if let jump = rpnElement as? Jump {
                if jump.type == .unconditional {
                    move(to: jump.label)
                } else {
                    if let prev = magazine.pop() as? ValueStorable, prev.value <= 0 {
                        move(to: jump.label)
                    }
                }
                continue
            }
            if let push = magazineElement, push is ValueStorable {
                magazine.push(push)
            }
        }
        
        return true
    }
    
    func send(_ mistake: RuntimeMistake) {
        let window = NSApplication.shared().mainWindow
        let viewController = window?.contentViewController as! ViewController
        viewController.print([mistake])
    }
    
    func move(to breakpoint: Label) {
        iterator = input.makeIterator()
        while let next = iterator.next() {
            if let label = next as? Label, label == breakpoint {
                break
            }
        }
    }
    
    func write(_ value: ValueStorable ) {
        let dict = ["tokens": value]
        NotificationCenter.default.post(name: .writeToConsole, object: self, userInfo: dict)
    }
    
    
    func read(_ value: ValueAccesible) {
        let window = NSApplication.shared().mainWindow
        let viewController = window?.contentViewController as! ViewController

        let idn = value as! Identifier
        let input = viewController.readVariable(idn.representation)
        let stringNumber = input.trimmingCharacters(in: CharacterSet.whitespaces)
        let num = Int(stringNumber)!
        value.set(num)
        
//        NotificationCenter.default.post(name: .readFromConsole, object: self, userInfo: dict)
    }
}

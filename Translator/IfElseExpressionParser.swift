//
//  IfElseExpressionParser.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/27/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class IfElseExpressionParser: ReversePolishNotationParser {
    
    override func generateReversePolishNotation() {
        
        var nextType: TransitionType = .falseT
        makeSnapshot()

        while let token = input.dequeue(), token.lexeme != OperatorPool.endif {
            print(token)
            if token.lexeme is ValueStorable, let value = token.lexeme as? ReversePolishNotation {
                output.append(value)
                makeSnapshot()
            } else if let currentOperation = token.lexeme as? SimplePolishOperator {
                if magazine.isEmpty {
                    magazine.push(currentOperation)
                    makeSnapshot()
                } else if token.lexeme == OperatorPool.elseKeyword {
                    while let top = magazine.top, top != OperatorPool.ifKeyword {
                        let _ = magazine.pop()
                        output.append(top)
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
            if let subparser = subparser() {
                while let next = magazine.top, next != OperatorPool.ifKeyword {
                    let _ = magazine.pop()
                    output.append(next)
                    makeSnapshot()
                }
                if let ifKeyWord = magazine.top as? MarkKeeper {
                    let transition = Transition(nextType)
                    ifKeyWord.marks.append(transition)
                    output.append(transition)
                    if transition.type == .gotoT {
                        output.append(ContentTransition(transition))
                    }
                    makeSnapshot()
                    nextType = nextType == .falseT ? .gotoT : .falseT
                } else {
                    let _ = magazine.pop()
                    let transition = Transition(nextType)
                    let markKeeper = MarkKeeper(OperatorPool.ifKeyword, transition)
                    magazine.push(markKeeper)
                    
                    output.append(transition)
                    makeSnapshot()
                    nextType = nextType == .falseT ? .gotoT : .falseT
                }
                
                subparser.generateReversePolishNotation()
                append(subparser.snapshots)
                self.input = subparser.input
                output.append(contentsOf: subparser.output)
                makeSnapshot()
            }
        }
        let _ = input.dequeue()
        
        while let top = magazine.top, top != OperatorPool.ifKeyword {
            let _ = magazine.pop()
            output.append(top)
            makeSnapshot()
        }
        
        let ifKeyword = magazine.pop() as! MarkKeeper
        let transition = ContentTransition(ifKeyword.marks.first!)
        output.append(transition)
        
        makeSnapshot()
    }
    
    override func evaluate() {

    }
}

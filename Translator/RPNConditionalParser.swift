//
//  RPNConditionalParser.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/29/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class RPNConditionpalParser: RPNParser {
    
    var m1: Label!
    var m2: Label!
    var tokens: [Token]
    
    var type: JumpType = .falseCondition
    
    override init(_ input: inout Queue<Token>) {
        self.tokens = input.array
        super.init(&input)
        self.lastLexeme = OperatorPool.endif
    }
    
    
    override func customAppend(_ operation: SimplePolishOperator) -> Bool {
        var result = false
        
        switch operation {
        case OperatorPool.closeBracket:
            while let pop = magazine.pop(), pop != OperatorPool.openBracket {
                output.append(pop)
            }
        return true
        case OperatorPool.then:
            popAll(to: OperatorPool.ifKeyword)
            let jump = Jump(.falseCondition, Label())
            let ifKey = magazine.pop()!
            let keeper = RPNLabelKeeper(ifKey.representation, ifKey.stackPriority, ifKey.comparePriority, ifKey.rpn)
            keeper.labels.append(jump.label)
            magazine.push(keeper)
            output.append(jump)
            result = true
        case OperatorPool.elseKeyword:
            popAll(to: OperatorPool.ifKeyword)
            let jump = Jump(.unconditional, Label())
            let keeper = magazine.pop()! as! RPNLabelKeeper
            keeper.labels.append(jump.label)
            magazine.push(keeper)
            output.append(jump)
            output.append(keeper.labels.first!)
            result = true
        default:
            break
        }
        
        return result
    }
    
    override func magazineWillBecomeEmpty() {
        let ifKey = magazine.pop()! as! RPNLabelKeeper
        output.append(ifKey.labels.last!)
        snapshots.removeLast()
        
//        labels[1].rpnIndex = output.count
    }
    
    
    override func replace(_ operation: SimplePolishOperator, at position: TextPoint) -> SimplePolishOperator {
        var result = operation
        
        if operation === OperatorPool.minus, let token = tokens.first(where: { $0.position == position }) {
            if let index = tokens.index(of: token) {
                let previndex = tokens.index(before: index)
                let prev = tokens[previndex]
                if prev.lexeme is Terminal {
                    result = OperatorPool.unaryMinus
                }
            }
        }
        
        return result
    }
}


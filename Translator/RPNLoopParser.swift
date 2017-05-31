//
//  RPNLoopParser.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/30/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class RPNLoopParser: RPNParser {
    var label1: Label!
    var label2: Label!
    var label3: Label!
    var workLabel1: Identifier!
    var workLabel2: Identifier!
    var loop: Int!
    var loopLabel: Identifier!
    var isNeededSubparser = false
    
    
    override init(_ input: inout Queue<Token>) {
        super.init(&input)
        self.lastLexeme = OperatorPool.next
    }

    
    override func parse() -> Bool {
        snapshot()
        
        while let token = input.dequeue(), token.lexeme != lastLexeme {
            if appendAsValue(of: token) {
                snapshot()
            } else if var operation = token.lexeme as? SimplePolishOperator {
                if operation == OperatorPool.forKeyword {
                    label1 = Label()
                    label2 = Label()
                    label3 = Label()
                    loop = 1
                    let keeper = RPNLabelKeeper(operation.representation, operation.stackPriority, operation.comparePriority, operation.rpn)
                    keeper.labels.append(label1)
                    keeper.labels.append(label2)
                    keeper.labels.append(label3)
                    magazine.push(keeper)
                } else if magazine.isEmpty {
                    magazine.push(operation)
                } else if !customAppend(operation) {
                    appendByPriority(operation)
                }
                snapshot()
            }
            if isNeededSubparser, let nestedParser = RPNParser.parser(for: &input) {
                nestedParserWillWork()
                nestedParser.parse()
                merge(nestedParser)
                nestedParserDidWork()
                while let nextNestedParser = RPNParser.parser(for: &input) {
                    nextNestedParser.parse()
                    merge(nextNestedParser)
                }
            }
        }
        popAll(to: OperatorPool.forKeyword)
        output.append(Jump(.unconditional, label1))
        output.append(label3)
        
        let _ = magazine.pop()
        magazineWillBecomeEmpty()
        popAll(to: nil)
        snapshot()
        
        print(output)
        return true
    }
    
    override func customAppend(_ operation: SimplePolishOperator) -> Bool {
        switch operation {
        case OperatorPool.assignValue:
            if loop == 1, let last = output.last as? Identifier {
                loopLabel = last
                loop = 0
            }
        case OperatorPool.step:
            popAll(to: OperatorPool.forKeyword)
            workLabel1 = Identifier("r1")
            workLabel2 = Identifier("r2")
            output.append(workLabel1)
            output.append(loopLabel)
            output.append(OperatorPool.assignValue)
            output.append(label1)
            output.append(workLabel2)
            return true
        case OperatorPool.to :
//            :=rj 0:=mi+1 УПЛllrj+1 +:=mi+1:rj0:=l.
            popAll(to: OperatorPool.forKeyword)
            output.append(OperatorPool.assignValue)
            output.append(workLabel1)
            output.append(Constant(0))
            output.append(OperatorPool.equal)
            output.append(Jump(.falseCondition, label2))
            output.append(loopLabel)
            output.append(loopLabel)
            output.append(workLabel2)
            output.append(OperatorPool.plus)
            output.append(OperatorPool.assignValue)
            output.append(label2)
            output.append(workLabel1)
            output.append(Constant(0))
            output.append(OperatorPool.assignValue)
            output.append(loopLabel)
            return true
        case OperatorPool.doKeyword:
            popAll(to: OperatorPool.forKeyword)
            output.append(OperatorPool.minus)
            output.append(workLabel2)
            output.append(OperatorPool.multiply)
            output.append(Constant(0))
            output.append(OperatorPool.lessOrEqualThan)
            output.append(Jump(.falseCondition, label3))
            isNeededSubparser = true
            return true
        default:
            break
        }
        return false
    }
}

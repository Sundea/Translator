//
//  Parser.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/22/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class Parser {
    
    let parsingTable: ParsingTable
    
    private lazy var stack = Stack<ParsingTableAccesible>()
    private var inputStream: Queue<ParsingTableAccesible>!
    lazy var polish = [ReversePolishElement]()
    var input: [Token]! {
        didSet {
            prepare()
        }
    }
    
    /// Logs
    lazy var snapshots = [ParserSnapshot]()
    
    /// Contains mistakes if there is, otherwise - empty array
    lazy var mistakes = [Mistake]()
    
    
    init(_ parsingTable: ParsingTable) {
        self.parsingTable = parsingTable
    }
    
    func prepare() {
        stack.push(parsingTable.startEndToken as ParsingTableAccesible)
        var inputs = input as [ParsingTableAccesible]
        inputs.append(parsingTable.startEndToken)
        inputStream = Queue<ParsingTableAccesible>(inputs)
    }
    
    func parse() {
        var flag = false
        while inputStream.count > 1 || stack.count > 2  {
            if let input = inputStream.front, input.tableKey != parsingTable.startEndToken.tableKey {
                if let relation = parsingTable[stack.top!, input] {
                    makeSnapshot(stack, relation, inputStream, polish)
                    if let key = stack.top?.tableKey {
                        if key == ":=" || key == ")" {
                            flag = true
                        } else if key == "write" || key == "read"{
                            flag = false
                        }
                    }
                    if flag && (input.tableKey == "@Identifier" || input.tableKey == "@Constant") {
                        let value = input as! Token
                        polish.append(value.lexeme as! ReversePolishElement)
                    }
                    if relation != .moreThan  {
                        stack.push(input)
                        let _ = inputStream.dequeue()
                    } else {
                        let _ = minimize()
                    }
                } else {
                        let nextLexeme = input as! Token
                        let index = self.input.index { key in
                            return key == nextLexeme
                        }
                        let prev = self.input[self.input.index(before: index!)]
                        let mistake = SyntaxMistake(prev, nextLexeme)
                        mistakes.append(mistake)
                        return
                }
            } else {
                let _ = minimize()
            }
        }
        
        if let last = snapshots.last {
            let added = last.inputStreamDescription.trimmingCharacters(in:CharacterSet(charactersIn: "#"))
            let stack = last.stackDescription + added
            let snapshot = ParserSnapshot(stack, Relation.moreThan.description, "#", polish.reduce("") { result, element in "\(result) \(element.stringValue)" })
            snapshots.append(snapshot)
        }
        
        
        if let top = stack.top, top.tableKey != "<root>" {
            if let last = input.last {
                mistakes.append(UnexpectedEndOfFile(last))
            }
        }
    }
    
    private func minimize() -> Bool {
        var ruleCandidate = [String]()
        var isMinimized = false
        while !stack.isEmpty && stack.top?.tableKey != "<root>" {
            let previous = stack.pop()!
            ruleCandidate.append(previous.tableKey)
            
            if let next = stack.top {
                if let relation = parsingTable.value(for: next, previous), relation == .lessThan {
                    let reversed: [String] =  ruleCandidate.reversed()
                    if let minimized = parsingTable.nonTerminal(for: reversed) {
                        print(minimized.tableKey)
                        if ruleIsEqualTo(["<multiplier>", "^", "<firstExpression>"], to: reversed) {
                            polish.append(OperatorPool.power)
                            makeSpecial()
                        } else if ruleIsEqualTo(["<term>", "/", "<multiplier1>"], to: reversed){
                            polish.append(OperatorPool.divide)
                            makeSpecial()
                        } else if ruleIsEqualTo(["<term>", "*", "<multiplier1>"], to: reversed) {
                            polish.append(OperatorPool.multiply)
                            makeSpecial()
                        } else if ruleIsEqualTo(["-", "<term1>"], to: reversed) {
                            polish.append(OperatorPool.unaryMinus)
                            makeSpecial()
                        } else if ruleIsEqualTo(["<expression>", "-", "<term1>"], to: reversed) {
                            polish.append(OperatorPool.minus)
                            makeSpecial()
                        } else if ruleIsEqualTo(["<expression>", "+", "<term1>"], to: reversed) {
                            polish.append(OperatorPool.plus)
                            makeSpecial()
                        }
                        
                        stack.push(minimized)
                        isMinimized = true
                    }
                    break
                }
            }
        }
        
        return isMinimized
    }
    
    func makeSpecial() {
        let last: ParserSnapshot = snapshots.removeLast()
        makeSnapshot(stack, .moreThan, self.inputStream, polish)
        let prevLast: ParserSnapshot = snapshots.removeLast()
        let snapshot = ParserSnapshot.init(last.stackDescription, prevLast.relation, prevLast.inputStreamDescription, prevLast.rpn)
        snapshots.append(snapshot)
    }
    
    
    
    private func makeSnapshot(_ stack: Stack<ParsingTableAccesible>, _ relation: Relation, _ inputStream: Queue<ParsingTableAccesible>, _ polish: [ReversePolishElement]) {
        let stackDescription = description(from: stack.array)
        let relationDescription = relation.description
        let inputStreamDescription = description(from: inputStream.array)
        let rpn = polish.reduce("") { result, element in "\(result) \(element.stringValue)" }
        let snapshot = ParserSnapshot(stackDescription, relationDescription, inputStreamDescription, rpn)
        snapshots.append(snapshot)
    }
    
    
    private func description(from array:[ParsingTableAccesible]) -> String {
        return array.reduce("") { result, next in
            if let next = next as? Token {
                return "\(result) \(next.lexeme.representation)"
            } else {
                return "\(result) \(next.tableKey)"
            }
        }
    }
    
    private func ruleIsEqualTo(_ rule: [String], to otherRule: [String]) -> Bool {
        return rule == otherRule
    }
}






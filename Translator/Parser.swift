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
    
        while inputStream.count > 1 || stack.count > 2  {
            if let input = inputStream.front, input.tableKey != parsingTable.startEndToken.tableKey {
                if let relation = parsingTable[stack.top!, input] {
                    makeSnapshot(stack, relation, inputStream)
                    if relation != .moreThan  {
                        stack.push(input)
                        let _ = inputStream.dequeue()
                    } else {
                        let _ = minimize()
                    }
                } else {
//                    if !minimize() {
                        let nextLexeme = input as! Token
                        let index = self.input.index { key in
                            if let token = key as? Token {
                                return token == nextLexeme
                            }
                            return false
                        }
                        let prev = self.input[self.input.index(before: index!)]
                        let mistake = SyntaxMistake(prev, nextLexeme)
                        mistakes.append(mistake)
                        return
//                    }
                }
            } else {
                let _ = minimize()
            }
        }
        
        if let last = snapshots.last {
            let added = last.inputStreamDescription.trimmingCharacters(in:CharacterSet(charactersIn: "#"))
            let stack = last.stackDescription + added
            let snapshot = ParserSnapshot(stack, Relation.moreThan.description, "#")
            snapshots.append(snapshot)
        }
        
        
        if let top = stack.top, top.tableKey != "<root>" {
            if let last = input.last as? Token {
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
                    if let minimized = parsingTable.nonTerminal(for: ruleCandidate.reversed()) {
                        stack.push(minimized)
                        isMinimized = true
                    }
                    break
                }
            }
        }
        
        return isMinimized
    }
    
    private func makeSnapshot(_ stack: Stack<ParsingTableAccesible>, _ relation: Relation, _ inputStream: Queue<ParsingTableAccesible>) {
        let stackDescription = description(from: stack.array)
        let relationDescription = relation.description
        let inputStreamDescription = description(from: inputStream.array)
        let snapshot = ParserSnapshot(stackDescription, relationDescription, inputStreamDescription)
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
}






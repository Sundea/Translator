//
//  ParsingTableGenerator.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/21/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class ParsingTableGenerator {
    
    let terminalRegex = try! NSRegularExpression(pattern: "<[\\s\\S]+>")
    let dict: [String:Array<[String]>]
    lazy var result: ParsingTable = {
       return ParsingTable(self.dict)
    }()
    
    
    init(dict: [String:Array<[String]>]) {
        self.dict = dict
    }
    
    
    func work() {
        for (_, rules) in dict {
            for rule in rules {
                if let previous = rule.first {
                    var left = Key(token: previous)
                    var rigth: Key
                    for i in 1..<rule.count {
                        rigth = Key(token: rule[i])
                        
                        try! result.insert(value: .equal, for: left, rigth)
                        setLessThan(left, rigth)
                        setMoreThan(left, rigth)
                        left = rigth
                    }
                }
            }
        }
        
        var all = Set<String>(dict.keys)
        for (_, values) in dict {
            for subrule in values {
                all.formUnion(subrule)
            }
        }
        
        let special = Key(token: "#")
        for element in all {
            
            let other = Key(token: element)
            setLessThan(special, other)
            setMoreThan(other, special)
        }
    }
    
    private func setMoreThan(_ left: Key, _ right: Key) {
        
        guard let leftSet = lastPlus(left),
            // right is terminal
        let rightSet = isNonTerminal(right.key) ? firstPlus(right) : [right]
            else { return }
        
        for left in leftSet {
            rightSet.forEach() { right in
                try? result.insert(value: .moreThan, for: left, right)
            }
        }
    }
    
    private func isNonTerminal(_ token: String) -> Bool {
        let range = token.range
        let matchResult = terminalRegex.rangeOfFirstMatch(in: token, range: range)
        return NSEqualRanges(range, matchResult)
    }
    
    private func setLessThan(_ left: Key, _ right: Key) {
        let rightSet = firstPlus(right)
        rightSet?.forEach() { right in
            try! result.insert(value: .lessThan, for: left, right)
        }
    }
    
    
    fileprivate func lastPlus(_ token: Key) -> Set<Key>? {
        return conditionPlus(token) { $0.last }
    }
    
    
    fileprivate func firstPlus(_ token: Key) -> Set<Key>? {
        return conditionPlus(token) { $0.first }
    }
    
    private func conditionPlus(_ token: Key,_ condition: (_ subrule: [String]) -> String?) -> Set<Key>? {
        guard let rule = dict[token.key] else { return nil }
        
        var result = Set<Key>()
        for subrule in rule {
            if let first = condition(subrule) {
                let key = Key(token: first)
                if key != token {
                    result.insert(key)
                    
                    if let subres = conditionPlus(key, condition) {
                        result.formUnion(subres)
                    }
                }
            }
        }
        return result
    }
}


struct Key: ParsingTableToken, Equatable, Hashable {
    let token: String
    
    var key: String {
        return token
    }
    
    var hashValue: Int {
        return token.hash
    }
    
    static func ==(lhs: Key, rhs: Key) -> Bool {
        return lhs.token == rhs.token
    }
}

//
//  ParsingTable.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/20/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation


/// Parsing table errors
///
/// - conflict: represents conflict situation between keys and associated value
enum ParsingTableError: Error, CustomStringConvertible {
    case conflict(left: ParsingTableAccesible, right: ParsingTableAccesible, oldRelation: Relation, newRelation: Relation)
    
    var description: String {
        var result: String
        
        switch self {
        case .conflict(let left, let right, let oldRelation, let newRelation):
            result = "Threre is conflict between left token `\(left)` and right token `\(right)`. Trying to replace `\(oldRelation.rawValue)` to `\(newRelation.rawValue)`"
            break
        }
        return result
    }
}






/// Predictive parsing table for syntax analyzer
struct ParsingTable {
    
    /// Describes row in parsing table. Key is right token (column Token) in relation, value is relation.
    typealias Row = [String: Relation]
    
    
    // MARK: Properties
    
    let startEndToken = Terminal("#")
    
    /// Container for values
    fileprivate(set) var dictionary = [String: Row]()
    fileprivate(set) var rules: [String: [[String]]]
    
    init(_ rules: [String: [[String]]]) {
        self.rules = rules
    }
    
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return dictionary.description
    }
    
    
    
    // MARK: - Public
    
    /// Accesses the value associated with the given keys for reading.
    ///
    /// - Parameters:
    ///   - rowKey: left token in relation
    ///   - rightKey: right token in relation
    /// - Returns: The value associated with `keys` if `keys` are in the table;
    ///   otherwise, `nil`.
    subscript(rowKey: ParsingTableAccesible, columnKey: ParsingTableAccesible) -> Relation? {
        get {
            return value(for: rowKey, columnKey)
        }
    }
    
    
    /// Accesses the value associated with the given keys for reading.
    ///
    /// - Parameters:
    ///   - rowKey: left token in relation
    ///   - columnKey: right token in relation
    /// - Returns: The value associated with `keys` if `keys` are in the table;
    ///   otherwise, `nil`.
    func value(for rowKey: ParsingTableAccesible, _ columnKey: ParsingTableAccesible) -> Relation? {
        guard let row = dictionary[rowKey.tableKey],
            let value = row[columnKey.tableKey]
            else { return nil }
        
        return value
    }
    
    
    // MARK: Mutating
    
    /// Inserts the given relation value in the table.
    ///
    /// If value is `nil` and there is an element associated with `keys`, it may the same effect as removing relation.
    ///
    /// - Parameters:
    ///   - value: A relation to insert into the table
    ///   - rowKey: left token in relation
    ///   - rightKey: right token in relation
    /// - Throws: If threre is an element is already contained in table for given keys, this
    ///   method throws `ParsingTableError.confict(...)`.
    mutating func insert(value: Relation?, for rowKey: ParsingTableAccesible, _ columnKey: ParsingTableAccesible) throws {
        
        var row = dictionary[rowKey.tableKey] ?? Row()
        
        if let oldRelation = row[columnKey.tableKey], let newRelation = value, oldRelation != newRelation {
            throw ParsingTableError.conflict(left: rowKey, right: columnKey, oldRelation: oldRelation, newRelation: newRelation)
        }
        
        row[columnKey.tableKey] = value
        
        if row.isEmpty {
            dictionary.removeValue(forKey: rowKey.tableKey)
        } else {
            dictionary[rowKey.tableKey] = row
        }
    }

    
    /// Removes the value associated with the given keys for reading.
    ///
    /// - Parameters:
    ///   - rowKey: left token in relation
    ///   - columnKey: right token in relation
    /// - Returns: removed value; otherwise, `nil`
    mutating func removeValue(for rowKey: ParsingTableAccesible, columnKey: ParsingTableAccesible) -> Relation? {
        guard var row = dictionary[rowKey.tableKey],
            let value = row.removeValue(forKey: columnKey.tableKey)
            else { return nil }
        
        if row.isEmpty {
            dictionary.removeValue(forKey: rowKey.tableKey)
        }
        
        return value
    }
    
    
    func nonTerminal(for sequence: [String]) -> Key? {
        var result: Key?
    
        for (key, rule) in rules {
            if rule.contains(where: { $0 == sequence }) {
                result = Key(token: key)
                break
            }
        }
        
        return result
    }
}



// MARK: - JSON serialiation and deserialization
extension ParsingTable {
    
    /// Returns NSDictionry of raw data, ready for json serialization
    var json: NSDictionary {
        let jsonDict = NSMutableDictionary()
        
        for (rowKey, row) in dictionary {
            let jsonrowDict = NSMutableDictionary()
            
            for (columnKey, relation) in row {
                jsonrowDict.setValue(relation.rawValue, forKey: columnKey)
            }
            
            jsonDict.setValue(jsonrowDict, forKey: rowKey)
        }
        let jsonRules = rules as NSDictionary
        let json = NSMutableDictionary()
        json.setValue(jsonRules, forKey: "Rules Dict")
        json.setValue(jsonDict, forKey: "Parsing Table")
        return json
    }
    
    
    /// Initializes from json dictionary
    ///
    /// - Parameters:
    ///   - json: dictionary raw Parsing Table data
    init?(json: [String: Any]) {
        guard let rawDict = json["Parsing Table"] as? [String: [String: String]],
        let rulesDict = json["Rules Dict"] as? [String: [[String]]]
            else { return nil }
        
        self.rules = rulesDict
        for (rowKey, rawrow) in rawDict {
            var row = [String: Relation]()
            
            for (key, value) in rawrow {
                row[key] = Relation(rawValue: value)
            }
            dictionary[rowKey] = row
            
        }
    }
}


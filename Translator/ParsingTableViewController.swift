//
//  ParsingTableViewController.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/23/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Cocoa

class ParsingTableViewController: NSViewController {

    var snaphots: [ParserSnapshot]! {
        didSet {
            table.reloadData()
        }
    }
    
    
    @IBOutlet weak var table: NSTableView!
}


// MARK: - NSTableViewDataSource
extension ParsingTableViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return snaphots?.count ?? 0
    }
}


// MARK: - NSTableViewDelegate
extension ParsingTableViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let column = tableColumn else { return nil }
        let textCell = tableView.make(withIdentifier: column.identifier, owner: self) as? NSTableCellView ?? NSTableCellView()
        
        let snapshot = snaphots[row]
        var stringValue = ""
        switch column.identifier {
        case "Stack":
            stringValue = snapshot.stackDescription
        case "Count":
            stringValue = row.description
        case "InputStream":
            stringValue = snapshot.inputStreamDescription
        case "Relation":
            stringValue = snapshot.relation
        default:
            break
        }
        textCell.textField?.stringValue = stringValue
        
        return textCell
    }
}

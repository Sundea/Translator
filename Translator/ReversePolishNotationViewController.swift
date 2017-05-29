//
//  ReversePolishNotationViewController.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/25/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Cocoa

class ReversePolishNotationViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var polishResult: NSTextField!
    
    var parsingSnaphots: [ExpressionParserSnapshot]! {
        didSet {
            self.table.reloadData()
            if let snapshot = parsingSnaphots.last {
                polishResult.stringValue = snapshot.reversePolish
            }
        }
    }
    
    @IBOutlet weak var table: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return parsingSnaphots?.count ?? 0
    }
    
    
    // MARK: - NSTableViewDelegate
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let column = tableColumn else { return nil }
        let textCell = tableView.make(withIdentifier: column.identifier, owner: self) as? NSTableCellView ?? NSTableCellView()
        
        let snapshot = parsingSnaphots[row]
        var stringValue = ""
        switch column.identifier {
        case "Stack":
            stringValue = snapshot.stack
        case "Count":
            stringValue = row.description
        case "InputStream":
            stringValue = snapshot.inputStream
        case "ReversePolish":
            stringValue = snapshot.reversePolish
        default:
            break
        }
        
        textCell.textField?.stringValue = stringValue
        return textCell
    }

    
}

//
//  PresetViewController.swift
//  SoudtouchPresets
//
//  Created by Bastian Bukatz on 14.07.17.
//  Copyright © 2017 Bastian Bukatz. All rights reserved.
//


import UIKit
import Foundation

class PresetViewController: UITableViewController, XMLParserDelegate {
    
    var presets: [STPreset] = []
    var name: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.url(forResource: "presets", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
            }
        }
    }
        
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let preset = presets[indexPath.row]
        
        cell.textLabel?.text = book.bookTitle
        cell.detailTextLabel?.text = book.bookAuthor
        
        return cell
    }

        
}

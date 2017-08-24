//
//  PresetParser.swift
//  SoudtouchPresets
//
//  Created by Bastian Bukatz on 23.08.17.
//  Copyright © 2017 Bastian Bukatz. All rights reserved.
//

import Foundation

class PresetParser: NSObject, XMLParserDelegate {
        
    
    var presets: [Preset] = []
    var preset: Preset = Preset ()
    var eName = String()
    
    // 1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        eName = elementName
        if elementName == "preset" {
            preset = Preset()
            preset.id = Int(attributeDict["id"]!)!
        }
        else if elementName == "ContentItem" {
            preset.contentItem.source = attributeDict["source"]!
            preset.contentItem.location = attributeDict["location"]!
            preset.contentItem.sourceAccount = attributeDict["sourceAccount"]!
        }
    }
    
    // 2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if ( elementName == "preset" ) {
            presets.append(preset)
        }
    }
    
    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if (!data.isEmpty) {
            if eName == "itemName" {
                preset.contentItem.itemName += data
            }
        }
    }
}

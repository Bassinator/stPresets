//
//  VolumeParser.swift
//  SoudtouchPresets
//
//  Created by Bastian Bukatz on 06.09.17.
//  Copyright © 2017 Bastian Bukatz. All rights reserved.
//

import Foundation


class VolumeParser: NSObject, XMLParserDelegate {
    
    var volume: Volume? = nil;
    var eName = String()
    var targetvolumeString = String()
    var actualvolumeString = String()
    var muteenabledString = String()
    

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        eName = elementName
        if elementName == "volume" {
            let deviceID = String(attributeDict["deviceID"]!)!
            volume = Volume(deviceID: deviceID)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if ( elementName == "volume" ) {
            volume?.targetvolume = Int(targetvolumeString)!
            volume?.actualvolume = Int(actualvolumeString)!
            volume?.muteenabled = Bool(muteenabledString)!
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if (!data.isEmpty) {
            if eName == "targetvolume" {
                targetvolumeString += data
            }
            else if eName == "actualvolume" {
                actualvolumeString += data
            }
            else if eName == "muteenabled" {
                muteenabledString += data
            }
        }
    }
}

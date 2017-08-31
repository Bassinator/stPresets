//
//  Preset.swift
//  SoudtouchPresets
//
//  Created by Bastian Bukatz on 17.08.17.
//  Copyright © 2017 Bastian Bukatz. All rights reserved.
//
/*  <preset id="3" createdOn="1407926285" updatedOn="1461584034">
        <ContentItem unusedField="0" source="INTERNET_RADIO"
        l   ocation="635" sourceAccount="" isPresetable="true">
            <itemName>Radio Argovia 90.3</itemName>
        </ContentItem>
    </preset>   */

import Foundation
import os.log


class Preset : NSObject, NSCoding {
    var id: Int
    var contentItem = ContentItem();
    
    init(id: Int) {
        self.id = id
    }
    

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(contentItem.source, forKey: PropertyKey.source)
        aCoder.encode(contentItem.location, forKey: PropertyKey.location)
        aCoder.encode(contentItem.sourceAccount, forKey: PropertyKey.sourceAccount)
        // aCoder.encode(contentItem.isPresetable, forKey: PropertyKey.isPresetable)
        aCoder.encode(contentItem.itemName, forKey: PropertyKey.itemName)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let id = (aDecoder.decodeInteger(forKey: PropertyKey.id)) as Int! else {
            os_log("Unable to decode the id for a Preset object.", log: OSLog.default, type: .debug)
            return nil
        }
        let source = aDecoder.decodeObject(forKey: PropertyKey.source) as? String
        let location = aDecoder.decodeObject(forKey: PropertyKey.location) as? String
        let sourceAccount = aDecoder.decodeObject(forKey: PropertyKey.sourceAccount) as? String
        //let isPresetable = aDecoder.decodeObject(forKey: PropertyKey.isPresetable) as? Bool
        let itemName = aDecoder.decodeObject(forKey: PropertyKey.itemName) as? String
        // Must call designated initializer.
        let contentItem = ContentItem(source: source!, location: location!, sourceAccount: sourceAccount!, itemName: itemName!)
        self.init(id: id)
        self.contentItem = contentItem
        
    }
    
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("presets")

    
}

struct PropertyKey {
    static let id = "id"
    static let source = "source"
    static let location = "location"
    static let sourceAccount = "sourceAccount"
    static let isPresetable = "isPresetable"
    static let itemName = "itemName"
}




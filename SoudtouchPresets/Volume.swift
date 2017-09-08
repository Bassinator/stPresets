//
//  Volume.swift
//  SoudtouchPresets
//
//  Created by Bastian Bukatz on 06.09.17.
//  Copyright © 2017 Bastian Bukatz. All rights reserved.
//

import Foundation
import os.log

class Volume : NSObject, NSCoding  {
    var deviceID: String;
    var targetvolume: Int = 0
    var actualvolume: Int = 0
    var muteenabled: Bool = false
    
    init(deviceID: String){
        self.deviceID = deviceID
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(deviceID, forKey: PropertyKey.deviceID)
        aCoder.encode(targetvolume, forKey: PropertyKey.targetvolume)
        aCoder.encode(actualvolume, forKey: PropertyKey.actualvolume)
        aCoder.encode(muteenabled, forKey: PropertyKey.muteenabled)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let deviceID = (aDecoder.decodeObject(forKey: PropertyKey.deviceID)) as? String else {
            os_log("Unable to decode the id for a Preset object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(deviceID: deviceID)
        self.targetvolume = aDecoder.decodeInteger(forKey: PropertyKey.targetvolume)
        self.actualvolume = aDecoder.decodeInteger(forKey: PropertyKey.actualvolume)
        self.muteenabled = aDecoder.decodeBool(forKey: PropertyKey.muteenabled)
    }
    
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("presets")
    


struct PropertyKey {
    static let deviceID = "deviceID"
    static let targetvolume = "targetvolume"
    static let actualvolume = "actualvolume"
    static let sourceAccount = "sourceAccount"
    static let muteenabled = "muteenabled"
}
}


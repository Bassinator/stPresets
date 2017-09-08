//
//  ContentItem.swift
//  SoudtouchPresets
//
//  Created by Bastian Bukatz on 22.08.17.
//  Copyright © 2017 Bastian Bukatz. All rights reserved.
//


import Foundation

class ContentItem {
    var source = String()
    var location = String()
    var sourceAccount = String()
    var isPresetable = Bool()
    var itemName = String()
    
    init(){
        
    }
    
    init(source: String, location: String, sourceAccount: String, itemName: String) {
        self.source = source
        self.location = location
        self.sourceAccount = sourceAccount
        self.itemName = itemName
    }
}

//
//  ContentItem.swift
//  SoudtouchPresets
//
//  Created by Bastian Bukatz on 22.08.17.
//  Copyright © 2017 Bastian Bukatz. All rights reserved.
//
/*  <ContentItem unusedField="0" source="INTERNET_RADIO"
        location="635" sourceAccount="" isPresetable="true">
        <itemName>Radio Argovia 90.3</itemName>
    </ContentItem>    */

import Foundation

class ContentItem {
    var source = String()
    var location = String()
    var sourceAccount = String()
    var isPresetable = Bool()
    var itemName = String()
}

//
//  PresetViewController.swift
//  SoudtouchPresets
//
//  Created by Bastian Bukatz on 14.07.17.
//  Copyright © 2017 Bastian Bukatz. All rights reserved.
//


import UIKit
import Foundation
import MediaPlayer

class PresetViewController: UITableViewController {
    
    let presetParser = PresetParser()
    let soundtouch:HTTPCommunication = HTTPCommunication()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let presetsXml = soundtouch.getPreset()
        let xmlData = presetsXml.data(using: String.Encoding.utf8)!
        let parser = XMLParser(data: xmlData)
    
        parser.delegate = presetParser
        parser.parse()
        
        let volumeView = MPVolumeView(frame: CGRect(x: 0, y: 400, width: 300, height: 100))
        self.view.addSubview(volumeView)
        volumeView.backgroundColor = UIColor.red
        NotificationCenter.default.addObserver(self, selector: #selector(volumeChanged(notification:)),
                                               name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"),
                                               object: nil)
    }
    
    func volumeChanged(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            if let volumeChangeType = userInfo["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as? String {
                if volumeChangeType == "ExplicitVolumeChange" {
                    soundtouch.volume()
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presetParser.presets.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let preset = presetParser.presets[indexPath.row]
        
        cell.textLabel?.text = String(preset.id)
        cell.detailTextLabel?.text = preset.contentItem.itemName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contentItem = presetParser.presets[indexPath.row].contentItem
        let itemString = "<ContentItem unusedField=\"0\" source=\"" + contentItem.source + "\" location=\"" + contentItem.location + "\" sourceAccount=\"" + contentItem.sourceAccount + "\" isPresetable=\"true\"><itemName>" + contentItem.itemName + "</itemName></ContentItem>"
        
        print("\n" + itemString + "\n")
        soundtouch.setSource(source: itemString)
    }

    
}

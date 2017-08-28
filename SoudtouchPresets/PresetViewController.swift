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
import os.log

class PresetViewController: UITableViewController {
  
    let presetParser = PresetParser()
    let soundtouch:HTTPCommunication = HTTPCommunication()
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            loadPresets()
        case 1:
            persistPresets()
        case 2:
            getPresetsFromST(mode: HTTPCommunication.Mode.ONLINE)
        case 3:
            getPresetsFromST(mode: HTTPCommunication.Mode.OFFLINE)
        default:
            break;
        }
    }
    
    
    func persistPresets() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(presetParser.presets, toFile: Preset.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Presets successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save presets...", log: OSLog.default, type: .error)
        }
        
    }
    
    func loadPresets() {
        presetParser.presets = (NSKeyedUnarchiver.unarchiveObject(withFile: Preset.ArchiveURL.path) as? [Preset])!
        self.loadView()
    }
    
    func getPresetsFromST(mode: HTTPCommunication.Mode){
        let presetsXml = soundtouch.getPreset(mode : mode)
        let xmlData = presetsXml.data(using: String.Encoding.utf8)!
        let parser = XMLParser(data: xmlData)
        
        parser.delegate = presetParser
        presetParser.presets.removeAll()
        parser.parse()
        
        self.loadView()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        // following to disable audio control with volume rocker
        let session = AVAudioSession.sharedInstance()
        do {
            // 1) Configure your audio session category, options, and mode
            // 2) Activate your audio session to enable your custom configuration
            try session.setActive(true)
        } catch let error as NSError {
            print("Unable to activate audio session:  \(error.localizedDescription)")
        }
        
        // observer volume rocker (hiding the view by displaying it outside the phone display)
        let volumeView = MPVolumeView(frame: CGRect(x: 0, y: -200, width: 320, height: 100))
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
                    if let volumeNotification = userInfo["AVSystemController_AudioVolumeNotificationParameter"] as? Float {
                        soundtouch.volume(level: volumeNotification)
                    }
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

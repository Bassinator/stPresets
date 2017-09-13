//
//  PresetViewController.swift
//  SoudtouchPresets
//
//  Created by Bastian Bukatz on 14.07.17.
//  Copyright © 2017 Bastian Bukatz. All rights reserved.
//


import UIKit
import Foundation
import os.log

class PresetViewController: UITableViewController {
  
    let presetParser = PresetParser()
    let soundtouch = Soundtouch()
    
    @IBOutlet private weak var status: UILabel!
    
    @IBOutlet weak var buttonBar: UISegmentedControl!

    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            loadPresets()
        case 1:
            persistPresets()
        case 2:
            getPresetsFromST(mode: Soundtouch.Mode.ONLINE)
        case 3:
            getPresetsFromST(mode: Soundtouch.Mode.OFFLINE)
        case 4:
            pushPresetsToST()
        default:
            break;
        }
    }
    
    func pushPresetsToST() {
        _ = soundtouch.getVolume()
        for index in 0...5 {
            let contentItem = presetParser.presets[index].contentItem
            let itemString = "<ContentItem unusedField=\"0\" source=\"" + contentItem.source + "\" location=\"" + contentItem.location + "\" sourceAccount=\"" + contentItem.sourceAccount + "\" isPresetable=\"true\"><itemName>" + contentItem.itemName + "</itemName></ContentItem>"
            soundtouch.setSource(source: itemString)
            
            soundtouch.setPreset(preset: index+1)
            
            // sleep(2)
        }
        //  soundtouch.setVolume(level: volume);
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
    
    func getPresetsFromST(mode: Soundtouch.Mode){
        let presetsXml = soundtouch.getPreset(mode : mode)
        let xmlData = presetsXml.data(using: String.Encoding.utf8)!
        let parser = XMLParser(data: xmlData)
        
        parser.delegate = presetParser
        presetParser.presets.removeAll()
        parser.parse()
        self.loadView()
    }
    
    override func loadView() {
        super.loadView()
        self.status.text = self.soundtouch.hostname.components(separatedBy: ".").first
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // search Soundtouch devices in background
        self.buttonBar.setEnabled(false, forSegmentAt: 2)
        self.buttonBar.setEnabled(false, forSegmentAt: 4)
        sleep(1)
        DispatchQueue.main.async {
            let resolver = SoundtouchResolver(){ (hostname: String, port: Int) in
                print("hostname: \(hostname)")
                self.soundtouch.hostname = hostname
                self.soundtouch.port = port
                self.buttonBar.setEnabled(true, forSegmentAt: 2)
                self.buttonBar.setEnabled(true, forSegmentAt: 4)
                self.status.text = self.soundtouch.hostname.components(separatedBy: ".").first
            }
            resolver.nsb.includesPeerToPeer = true
            resolver.nsb.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
            resolver.nsb.searchForServices(ofType:"_soundtouch._tcp.", inDomain: "local.")
            withExtendedLifetime((resolver)) {
                RunLoop.current.run()
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

    
}

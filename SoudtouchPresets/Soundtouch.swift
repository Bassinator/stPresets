//
//  HttpCommunication.swift
//  SoudtouchPresets
//
//  Created by Bastian Bukatz on 12.07.17.
//  Copyright © 2017 Bastian Bukatz. All rights reserved.
//

import Foundation

class Soundtouch {
    
    
    enum Mode {
        case ONLINE;
        case OFFLINE;
    }

    func getPreset(mode: Mode) -> String{
        let result = get(function: Function.presets)
        return String(data: result, encoding: String.Encoding.utf8)!
    }
    
    func setSource(source: String) {
        set(function: Function.select, postBody: source)
    }
    
    func getVolume() -> Int {
        let result = get(function: Function.volume)
        let parser = XMLParser(data: result)
        let volumeParser = VolumeParser();
        
        parser.delegate = volumeParser
        parser.parse()
        print(volumeParser.volume!.actualvolume)
        return volumeParser.volume!.actualvolume
    }
    
    func setVolume(level: Float){
        let volumeLevel = Int(round(level*100))
        set(function: Function.volume, postBody: "<volume>" + String(volumeLevel) + "</volume>")
    }

    
    func setPreset(preset: Int){
        set(function: Function.key, postBody: "<key state=\"press\" sender=\"Gabbo\">PRESET_" + String(preset) + "</key>")
        sleep(2);
        set(function: Function.key, postBody: "<key state=\"release\" sender=\"Gabbo\">PRESET_" + String(preset) + "</key>")
    }
    
    func get(function: Function) -> Data {
        let urlString = URL(string: "http://192.168.1.102:8090/" + function.rawValue)
        var result = Data()
        var responseBody:String = "";
        if let endpoint = urlString {
            let sem = DispatchSemaphore(value: 0)
            let task = URLSession.shared.dataTask(with: endpoint) { (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if data != nil {
                        if let stringData = String(data: data!, encoding: String.Encoding.utf8) {
                            responseBody = stringData
                            result = data!
                        }
                    }
                }
                sem.signal()
            }
            task.resume()
            sem.wait()
        }
        print(responseBody)
        return result;
    }
    
    func set(function: Function, postBody : String) {
        let urlString = URL(string: "http://192.168.1.102:8090/" + function.rawValue)
        var responseBody:String = "";
        if let endpoint = urlString {
            let sem = DispatchSemaphore(value: 0)
            var request = URLRequest(url: endpoint)
            request.httpMethod = "POST"
            request.httpBody = postBody.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                if error != nil {
                    print(error!)
                } else {
                    if data != nil {
                        if let stringData = String(data: data!, encoding: String.Encoding.utf8) {
                            responseBody = stringData
                        }
                    }
                }
                sem.signal()
            }
            task.resume()
            sem.wait()
        }
        print(responseBody)
    }
}

enum KeyState : String {
    case press = "press"
    case release = "release"
}

enum Function : String {
    case volume = "volume"
    case key = "key"
    case select = "select"
    case presets = "presets"
}



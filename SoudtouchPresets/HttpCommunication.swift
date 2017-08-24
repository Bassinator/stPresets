//
//  HttpCommunication.swift
//  SoudtouchPresets
//
//  Created by Bastian Bukatz on 12.07.17.
//  Copyright © 2017 Bastian Bukatz. All rights reserved.
//

import Foundation

class HTTPCommunication {

    func getPreset() -> String{

    let urlString = URL(string: "http://192.168.1.102:8090/presets")
    var responseString:String = ""
        
    if let endpoint = urlString {
        
        let sem = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: endpoint) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                if data != nil {
                    if let stringData = String(data: data!, encoding: String.Encoding.utf8) {
                        responseString = stringData
                        
                    }
                }
            }
            sem.signal()
        }
        task.resume()
        sem.wait()
        
        }
        print(responseString)
        return responseString
    }
    
    func setSource(source: String) {
        let urlString = URL(string: "http://192.168.1.102:8090/select")
        var responseString:String = ""
        
        if let endpoint = urlString {
            
            let sem = DispatchSemaphore(value: 0)
            
            var request = URLRequest(url: endpoint)
            request.httpMethod = "POST"
            let postString = source
            request.httpBody = postString.data(using: .utf8)
            
            
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if data != nil {
                        if let stringData = String(data: data!, encoding: String.Encoding.utf8) {
                            responseString = stringData
                            
                        }
                    }
                }
                sem.signal()
            }
            task.resume()
            sem.wait()
            
        }
        print(responseString)
        
    }
    
    func volume(){
        let urlString = URL(string: "http://192.168.1.102:8090/key")
        var responseString:String = ""
        
        if let endpoint = urlString {
            
            let sem = DispatchSemaphore(value: 0)
            
            var request = URLRequest(url: endpoint)
            request.httpMethod = "POST"
            let postString = "<key state=\"press\" sender=\"Gabbo\">VOLUME_DOWN</key>"
            request.httpBody = postString.data(using: .utf8)
            
            
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if data != nil {
                        if let stringData = String(data: data!, encoding: String.Encoding.utf8) {
                            responseString = stringData
                            
                        }
                    }
                }
                sem.signal()
            }
            task.resume()
            sem.wait()
            
        }
        print(responseString)

    }
    
}

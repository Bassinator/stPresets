//
//  BMNSDelegate.swift
//  SoudtouchPresets
//
//  Created by Bastian Bukatz on 09.09.17.
//  Copyright © 2017 Bastian Bukatz. All rights reserved.
//

import Foundation
import UIKit

class SoundtouchResolver : NSObject, NetServiceDelegate,
NetServiceBrowserDelegate {
    var nsb : NetServiceBrowser!
    var services = [NetService]()
    let callback: (String, Int) -> Void
    
    init(callback: @escaping (_ hostname: String, _ port: Int) -> Void) {
        self.callback = callback
        super.init()
        nsb = NetServiceBrowser()
        nsb.delegate = self
    }
    
    
    func updateInterface () {
        for service in self.services {
            if service.port == -1 {
                print("service \(service.name) of type \(service.type)" +
                    " not yet resolved")
                service.delegate = self
                service.resolve(withTimeout:10)
            } else {
                print("service \(service.name) of type \(service.type)," +
                    "port \(service.port), hostname \(service.hostName), addresses \(service.addresses)")
                print(service.hostName ?? "")
                callback(service.hostName!, service.port);
            }
        }
    }
    
    
    // NetServiceDelegate
    func netServiceDidResolveAddress(_ sender: NetService) {
        print("adresse resolved")
        self.updateInterface()
    }
    
    // NetServiceBrowserDelegate
    func netServiceBrowser(_ aNetServiceBrowser: NetServiceBrowser, didFind aNetService: NetService, moreComing: Bool) {
        print("adding a service")
        self.services.append(aNetService)
        if !moreComing {
            self.updateInterface()
        }
    }
    
    func netServiceBrowser(_ aNetServiceBrowser: NetServiceBrowser, didRemove aNetService: NetService, moreComing: Bool) {
        if let ix = self.services.index(of:aNetService) {
            self.services.remove(at:ix)
            print("removing a service")
            if !moreComing {
                self.updateInterface()
            }
        }
    }
    
    func getSTHostname() -> String{
        nsb.searchForServices(ofType:"_soundtouch._tcp.", inDomain: "local.")
        return "";
    }

}

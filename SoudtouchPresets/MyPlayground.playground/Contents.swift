//: Playground - noun: a place where people can play

import UIKit

class BMNSDelegate : NSObject, NetServiceDelegate,
    NetServiceBrowserDelegate {
    var nsb : NetServiceBrowser!
    var services = [NetService]()
    

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
            }
        }
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        self.updateInterface()
    }
    
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
    
}

let sb = BMNSDelegate()
sb.services.removeAll()
sb.nsb = NetServiceBrowser()
sb.nsb.delegate = sb
sb.nsb.searchForServices(ofType:"_http._tcp.", inDomain: "local.")
RunLoop.current.run()
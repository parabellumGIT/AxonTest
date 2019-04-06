//
//  NetworkReachabilityManager.swift
//  ATestsAssignment
//
//  Created by Vitalii Shkliar on 4/6/19.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import Reachability

class NetworkReachabilityManager: NSObject {
    var reachability: Reachability!
    static let shared: NetworkReachabilityManager = {
        return NetworkReachabilityManager()
    }()
    
    override init() {
        super.init()
        //Initialise
        reachability = Reachability()
        //Observer for network status
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(networkStatusChanged(_: )),
                                               name: .reachabilityChanged,
                                               object: reachability)
        //Start notifier
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        //Do something globally here!
        
        
    }
    
    static func stopNotifier() -> Void {
        (NetworkReachabilityManager.shared.reachability).stopNotifier()
    }
    
    //Network is reachable
    static func isReachable(completed: @escaping (NetworkReachabilityManager) -> Void) {
        if (NetworkReachabilityManager.shared.reachability).connection != .none {
            completed(NetworkReachabilityManager.shared)
        }
    }
    
    //Network is unreachable
    static func isUnreachable(completed: @escaping (NetworkReachabilityManager) -> Void) {
        if (NetworkReachabilityManager.shared.reachability).connection == .none {
            completed(NetworkReachabilityManager.shared)
        }
    }
    
    //Network is reachable via WWAN/Cellular
    static func isReachableViaWWAN(completed: @escaping (NetworkReachabilityManager) -> Void) {
        if (NetworkReachabilityManager.shared.reachability).connection == .cellular {
            completed(NetworkReachabilityManager.shared)
        }
    }
    
    //Network is reachable via WIFI
    static func isReachableViaWifi(completed: @escaping (NetworkReachabilityManager) -> Void) {
        if (NetworkReachabilityManager.shared.reachability).connection == .wifi {
            completed(NetworkReachabilityManager.shared)
        }
    }
    
    
    
}

//
//  NetworkingService.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 4/28/22.
//

import Foundation
import SystemConfiguration
import Network

public enum ConnectionType: Int {
    case wifi
    case cellular
    case any
    
    
    var description: String {
        switch self {
        case.wifi:
            return "wifi connection"
        case .cellular:
            return "celluar connection"
        case .any:
            return "any connection?"
        }
    }
    
}


extension Notification.Name {
    static let networkingReachabilityDidChange = Notification.Name(rawValue: "NetworkingReachabilityDidChangeNofication")
}

let service = NetworkService()


class NetworkService {
    public var isReachable = true
    public var connectionType: ConnectionType?
    private let monitor = NWPathMonitor()

    public static func  startReachabilityMonitoring() {
        service.startReachability()
    }
    
    public static func  stopReachabilityMonitoring() {
        service.stopReachability()
    }
    

    func checkReachability(for connection: ConnectionType) -> Bool {
        guard isReachable else { return false }
        switch connection {
        case.wifi:
            return monitor.currentPath.usesInterfaceType(.wifi)
        case .cellular:
            return monitor.currentPath.usesInterfaceType(.cellular)
        case .any:
            return monitor.currentPath.usesInterfaceType(.wifi) ||
            monitor.currentPath.usesInterfaceType(.cellular) ||
            monitor.currentPath.usesInterfaceType(.other) ||
            monitor.currentPath.usesInterfaceType(.wiredEthernet) ||
            monitor.currentPath.usesInterfaceType(.loopback)
        }
    }
    
    func startReachability() {
        func setConnectionType(_ path: NWPath) {
            if path.usesInterfaceType(.wifi) {
                self.connectionType = .wifi
            } else if path.usesInterfaceType(.cellular) {
                self.connectionType = .cellular
            } else {
                self.connectionType = .any
            }
        }
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isReachable = true
                setConnectionType(path)
            } else {
                self.isReachable = false
                self.connectionType = nil
            }
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .networkingReachabilityDidChange, object: nil)
            }
        }
        
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
    }
    
    func stopReachability() {
        monitor.cancel()
    }
}



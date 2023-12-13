//
//  ReachabilityManager.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 29.11.2023.
//

import Foundation
import Network
import UIKit

protocol NetworkStatusMonitorDelegate_MWP : AnyObject {
    func statusChanged()
}

fileprivate class Melons: UIView {
    var iHateMelom: String = "true"
}

class NetworkStatusMonitor_MWP {
    static let shared = NetworkStatusMonitor_MWP()

    private let queue = DispatchQueue.global()
    private let nwMonitor: NWPathMonitor
    
    weak var delegate : NetworkStatusMonitorDelegate_MWP?

    public private(set) var isNetworkAvailable: Bool = false {
        didSet {
            self.delegate?.statusChanged()
        }
    }

    private init() {
// TEXT FOR FUNC REFACTOR
        nwMonitor = NWPathMonitor()
    }

    func startMonitoring_MWP() {
// TEXT FOR FUNC REFACTOR
        nwMonitor.start(queue: queue)
        nwMonitor.pathUpdateHandler = { path in
            self.isNetworkAvailable = path.status == .satisfied
        }
    }

    func stopMonitoring_MWP() {
// TEXT FOR FUNC REFACTOR
        nwMonitor.cancel()
    }
}

//  Created by Melnykov Valerii on 14.07.2023
//

import Foundation
import Network
import UIKit

protocol NetworkStatusMonitorDelegate_MWP : AnyObject {
    func showMess_MWP()
}

import UIKit

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
            if !isNetworkAvailable {
                DispatchQueue.main.async {
                    print("No internet connection.")
                    self.delegate?.showMess_MWP()
                }
            } else {
                DispatchQueue.main.async {
                    DropBoxBeautifulManager.shared.installDropBox()
                }
                print("Internet connection is active.")
            }
        }
    }

    private init() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        nwMonitor = NWPathMonitor()
    }

    func startMonitoring_MWP() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        nwMonitor.start(queue: queue)
        nwMonitor.pathUpdateHandler = { path in
            self.isNetworkAvailable = path.status == .satisfied
        }
    }

    func stopMonitoring_MWP() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        nwMonitor.cancel()
    }
}

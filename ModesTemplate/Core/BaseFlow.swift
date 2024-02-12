//
//  BaseFlow.swift
//  ModesTemplate
//
//  
//

import Foundation
import UIKit

protocol BaseFlowProtocol: AnyObject {
    
    var childCoordinators: [BaseFlowProtocol] { get set }
    
    func launchViewController() -> RootViewController?
    func addChildCoordinator(_ coordinator: BaseFlowProtocol)
}

extension BaseFlowProtocol {
    func addChildCoordinator(_ coordinator: BaseFlowProtocol) {
        childCoordinators.append(coordinator)
    }
}

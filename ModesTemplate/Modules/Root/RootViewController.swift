//
//  RootViewController.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 23.11.2023.
//

import Foundation
import UIKit

protocol RooViewControllerDelegate: AnyObject {
    func contentReady()
}

final class RootViewController: UINavigationController {
    
    lazy var viewModel: RootViewModel = {
       var model = RootViewModel(delegate: self)
        return model
    }()
    
    weak var flowDelegate: RootViewModelDelegate?
    
    init(flowDelegate: RootViewModelDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.flowDelegate = flowDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.navigationBar.isHidden = true
        viewModel.start()
    }
}

extension RootViewController: NetworkStatusMonitorDelegate_MWP {
    func statusChanged() {
        self.viewModel.start()
    }
}

extension RootViewController: RootViewModelDelegate {
    func contentReady() {
        self.navigationBar.isHidden = false
        self.flowDelegate?.contentReady()
    }
}

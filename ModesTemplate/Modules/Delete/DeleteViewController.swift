//
//  CustomAlertViewController.swift
//  ModesTemplate
//
//  Created by evhn on 29.11.2023.
//

import UIKit

enum CustomAlertConfig {
    case myWorksDelete(modName: String)
    case itemsFavourite(style: String)
    case custom(title: String, description: String)
    
    var title: String {
        switch self {
        case .myWorksDelete(let mod):
            return mod
        case .itemsFavourite:
            return "Alert"
        case .custom(let title, _):
            return title
        }
    }
    
    var description: String {
        switch self {
        case .myWorksDelete(_):
            return "Are you sure want to delete this mode?"
        case .itemsFavourite:
            return "Would you like to delete a skin from your favorites?"
        case .custom(_, let description):
            return description
        }
    }
}

final class CustomAlertViewController: UIViewController {
    
    lazy var customAlertView: CustomAlertView = {
       var view = CustomAlertView()
        view.deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        view.cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return view
    }()
    
    var deleteHandler: (() -> Void)?
    
    init(alertStyle: CustomAlertConfig) {
        super.init(nibName: nil, bundle: nil)
        configureAlert(type: alertStyle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = customAlertView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.7)
    }
}

private extension CustomAlertViewController {
    
    @objc func deleteAction() {
        self.deleteHandler?()
        self.dismiss(animated: true)
    }
    
    @objc func cancelAction() {
        self.dismiss(animated: true)
    }
    
    func configureAlert(type: CustomAlertConfig) {
        customAlertView.setupAlert(type: type)
    }
}

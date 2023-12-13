//
//  BaseViewController.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 23.11.2023.
//

import Foundation
import UIKit
import SDWebImage

protocol BaseViewControllerDelegate: AnyObject {
    func openMenu()
    func showDeteil(item: DeteilModel, type: ContentType)
    func showDeteilEditor(imageData: Data, title: String)
    func showDeteilEditor(objct: EditorDeteilModel, title: String)
    func openSub(style: PremiumMainController_MWPStyle)
    func navigateToController(filter: FilterMods)
}

class BaseViewController: UIViewController {
    
    var controllerType: ControllersType
    weak var flowDelegate: BaseViewControllerDelegate?
    var emptyCollection: ((Bool) -> Void)?
    
    init(controllerType: ControllersType) {
        self.controllerType = controllerType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = controllerType.title
        self.configureNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !NetworkStatusMonitor_MWP.shared.isNetworkAvailable {
            showConectionAlert()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SDImageCache.shared.clear(with: .all)
    }
    
    @objc func showMenu() {
        self.flowDelegate?.openMenu()
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func addHideKeyboardGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gesture)
    }
    
    func makeBackButton() {
        let buttonImage = AppConfig.Icons.backButton
        let backButton = createButton(config: [(buttonImage, #selector(backAction))])
        
        navigationItem.leftBarButtonItems = backButton
    }
    
    func createButton(config: [(UIImage?, Selector)]) -> [UIBarButtonItem] {
        var barButtons: [UIBarButtonItem] = []
        config.forEach { config in
            let button = UIButton(type: .custom)
            button.setBackgroundImage(config.0, for: .normal)
            button.addTarget(self, action: config.1, for: .touchUpInside)
            
            let isPad = UIDevice.current.userInterfaceIdiom == .pad
            let buttonSize = CGSize(width: isPad ? 38 : 25, height: isPad ? 38 : 25)
            button.frame = CGRect(origin: .zero, size: buttonSize)
            button.tintColor = .white
            let barButton = UIBarButtonItem(customView: button)
            barButtons.append(barButton)
        }
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 60
        if isPad {
            barButtons.insert(spacer, at: 0)
        }
        return barButtons
    }
    
    func checkConection() -> Bool {
        guard NetworkStatusMonitor_MWP.shared.isNetworkAvailable else {
            showConectionAlert()
            return false
        }
        return true
    }
}

private extension BaseViewController {
    
    func showConectionAlert() {
        let alert = UIAlertController(title: NSLocalizedString("ConnectivityTitle", comment: ""), message: NSLocalizedString("ConnectivityDescription", comment: ""), preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func configureNavBar() {
        
        let buttonImage = UIImage(named: "menu")
        let menuButton = createButton(config: [(buttonImage, #selector(showMenu))])
        
        navigationItem.leftBarButtonItems = menuButton
        
        let appearence = UINavigationBarAppearance()
        appearence.configureWithOpaqueBackground()
        appearence.shadowColor = nil // Убирает тень/полосу
        appearence.backgroundColor = .clear
        guard let font = UIFont(size: 22, type: .semiBold) else { return }
        appearence.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : AppConfig.Colors.titleViewControllerColor,
            NSAttributedString.Key.font : font]
        
        navigationController?.navigationBar.standardAppearance = appearence
        navigationController?.navigationBar.scrollEdgeAppearance = appearence
    }
}

extension BaseViewController: BannerViewDelegate {
    func openSub(style: PremiumMainController_MWPStyle) {
        self.flowDelegate?.openSub(style: style)
    }
}

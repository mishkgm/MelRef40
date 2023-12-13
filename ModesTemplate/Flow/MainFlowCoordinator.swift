//
//  MainFlowCoordinator.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 23.11.2023.
//

import Foundation
import UIKit

// MARK: - MainFLow
enum ControllersType: Int, CaseIterable {
    case mods
    case editor
    case skins
    case myWorks
    case favourite
    case items
    case settings
    
    var viewController: BaseViewController {
        switch self {
        case .mods:
            return ModsViewController(controllerType: self)
        case .skins:
            return ItemsViewController(controllerType: self)
        case .items:
            return ItemsViewController(controllerType: self)
        case .editor:
            return EditorViewController(controllerType: self)
        case .favourite:
            return FavouritesViewController(controllerType: self)
        case .myWorks:
            return MyWorksViewController(controllerType: self)
        case .settings:
            return SettingsViewController(controllerType: self)
        }
    }
    
    var title: String {
        switch self {
        case .mods:
            return localizedString(forKey: "mods")
        case .skins:
            return localizedString(forKey: "skins")
        case .items:
            return localizedString(forKey: "items")
        case .editor:
            return localizedString(forKey: "editor")
        case .favourite:
            return localizedString(forKey: "favourite")
        case .myWorks:
            return localizedString(forKey: "myWorks")
        case .settings:
            return localizedString(forKey: "setting")
        }
    }
}

final class MainFlowCoordinator: BaseFlowProtocol {
    
    private var viewController: RootViewController?
    private var currentController: ControllersType = .mods {
        didSet {
            changeCurrentController()
        }
    }
    var childCoordinators: [BaseFlowProtocol] = []
    
    public func launchViewController() -> RootViewController? {
        let mainController = RootViewController(flowDelegate: self)
        self.viewController = mainController
        return viewController
    }
}

// MARK: - Root
extension MainFlowCoordinator: RootViewModelDelegate, BaseViewControllerDelegate, MenuViewControllerDelegate {
    func openSub(style: PremiumMainController_MWPStyle) {
        let vc = PremiumMainController_MWP()
        vc.productBuy = style
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.viewController?.present(vc, animated: true)
    }
    
    func showDeteilEditor(objct: EditorDeteilModel) {
        let vc = DeteilEditorViewController(objct: RealmEditorDeteilModel(editorDeteilModel: objct))
        self.viewController?.pushViewController(vc, animated: true)
    }
    
    func showDeteilEditor(imageData: Data, title: String) {
        let vc = DeteilEditorViewController(imageData: imageData, title: title)
        self.viewController?.pushViewController(vc, animated: true)
    }
    
    func showDeteil(item: DeteilModel, type: ContentType) {
        let vc = DeteilViewController(model: item, type: type)
        vc.flowDelegate = self
        self.viewController?.pushViewController(vc, animated: true)
    }
    
    func contentReady() {
        didSelectIndex(0)
    }
    
    func openMenu() {
        let viewController = MenuViewController(delegate: self, currentIndex: currentController.rawValue)
        viewController.modalPresentationStyle = .overCurrentContext
        self.viewController?.present(viewController, animated: false)
    }
    
    func didSelectIndex(_ index: Int) {
        if index == ControllersType.editor.rawValue && !IAPManager_MWP.shared.productBought.contains(.unlockFuncProduct) {
            self.viewController?.presentedViewController?.dismiss(animated: true)
            openSub(style: .unlockFuncProduct)
        } else if index == ControllersType.skins.rawValue && !IAPManager_MWP.shared.productBought.contains(.unlockOther) {
            self.viewController?.presentedViewController?.dismiss(animated: true)
            openSub(style: .unlockOther)
        } else {
            self.currentController = ControllersType(rawValue: index) ?? .mods
            self.viewController?.presentedViewController?.dismiss(animated: true)
        }
    }
}

// MARK: - Private
private extension MainFlowCoordinator {
    func changeCurrentController() {
        let vc = currentController.viewController
        vc.flowDelegate = self
        viewController?.viewControllers = [vc]
    }
}

// MARK: - Sub
extension MainFlowCoordinator: PremiumMainController_MWPDelegate {
    func openApp_MWP() {
        self.viewController = launchViewController()
    }
    
    func funcBought() {
        self.didSelectIndex(ControllersType.editor.rawValue)
    }
    
    func contentBought() {
        self.didSelectIndex(ControllersType.mods.rawValue)
    }
}

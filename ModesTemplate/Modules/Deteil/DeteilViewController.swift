//
//  DeteilViewController.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 28.11.2023.
//

import Foundation
import UIKit

final class DeteilViewController: BaseViewController {
    
    var mainView: BaseView?
    
    lazy var itemsDeteilView: ItemsDeteilView = {
        var view = ItemsDeteilView()
        view.downloadButton.addTarget(self, action: #selector(downloadAction), for: .touchUpInside)
        view.exportButton.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        view.favouriteButton.addTarget(self, action: #selector(favouriteAction), for: .touchUpInside)
        view.bannerView.subDelegate = self
        return view
    }()
    
    lazy var modDeteilView: DeteilView = {
        var view = DeteilView()
        view.favouriteButton.addTarget(self, action: #selector(favouriteAction), for: .touchUpInside)
        view.startEditButton.addTarget(self, action: #selector(startEditAction), for: .touchUpInside)
        view.bannerView.subDelegate = self
        return view
    }()
    
    private var viewModel: DeteilViewModel
    
    init(model: DeteilModel, type: ContentType) {
        self.viewModel = DeteilViewModel(model: model, type: type)
        super.init(controllerType: .mods)
        switch type {
        case .mods:
            mainView = modDeteilView
        case .items, .skins, .maps:
            mainView = itemsDeteilView
        default: break
        }
        self.viewModel.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        self.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !IAPManager_MWP.shared.productBought.contains(.unlockFuncProduct) {
            self.modDeteilView.lockView(false)
        }
    }
    
    func configureView() {
        self.itemsDeteilView.configureView(viewModel.model)
        self.itemsDeteilView.configureButtons(for: viewModel.checkIfFileExist())
        self.modDeteilView.configureView(viewModel.model)
        self.modDeteilView.lockView(IAPManager_MWP.shared.productBought.contains(.unlockFuncProduct))
        let index = isPad ? 1 : 0
        if viewModel.type == .mods {
            self.navigationItem.rightBarButtonItems?[0 + index].isEnabled = !viewModel.checkIfFileExist()
            self.navigationItem.rightBarButtonItems?[0 + index].customView?.alpha = viewModel.checkIfFileExist() ? 0.5 : 1
            self.navigationItem.rightBarButtonItems?[1 + index].isEnabled = viewModel.checkIfFileExist()
            self.navigationItem.rightBarButtonItems?[1 + index].customView?.alpha = viewModel.checkIfFileExist() ? 1 : 0.5
            if viewModel.model.image == nil {
                self.viewModel.downloadImage(imageView: self.modDeteilView.imageView)
            }
        } else if viewModel.type == .maps || viewModel.type == .items {
            self.navigationItem.rightBarButtonItems?[0 + index].isEnabled = viewModel.checkIfFileExist()
            self.navigationItem.rightBarButtonItems?[0 + index].customView?.alpha = viewModel.checkIfFileExist() ? 1 : 0.5
        }
    }
    
    @objc func favouriteAction() {
        if viewModel.model.isFavourite {
            openFavAlert()
        } else {
            self.viewModel.toggleFavouriteStatus()
            self.itemsDeteilView.configureView(self.viewModel.model)
            self.modDeteilView.configureView(self.viewModel.model)
        }
    }
    
    @objc func downloadAction() {
        guard checkConection() else { return }
        self.viewModel.downloadMod()
        self.itemsDeteilView.downloadButton.isEnabled = false
        let index = isPad ? 1 : 0
        if viewModel.type == .mods {
            self.navigationItem.rightBarButtonItems?[0 + index].isEnabled = false
        }
    }
    
    @objc func shareAction() {
        self.viewModel.shareMod()
    }
    
    @objc func startEditAction() {
        if !IAPManager_MWP.shared.productBought.contains(.unlockFuncProduct) {
            openSubScreen()
        } else {
            guard let image = self.viewModel.model.image else { return }
            if let imageData = image.pngData() {
                self.flowDelegate?.showDeteilEditor(imageData: imageData, title: self.viewModel.model.title)
            }
        }
    }
    
    func setupNavBar() {
        makeBackButton()
        let buttonImage = AppConfig.Icons.backButton
        let shareImage = AppConfig.Icons.shareIcon
        let downloadImage = AppConfig.Icons.saveicon
        switch viewModel.type {
        case .items: self.title = "Weapon"
            let rightButtons = createButton(config: [(shareImage, #selector(shareAction))])
            self.navigationItem.rightBarButtonItems = rightButtons
        case .mods: self.title = "Mods"
            let rightButtons = createButton(config: [(downloadImage, #selector(downloadAction)), (shareImage, #selector(shareAction))])
            self.navigationItem.rightBarButtonItems = rightButtons
        case .skins: self.title = "Skins"
        case .maps: self.title = "Map"
            let rightButtons = createButton(config: [(shareImage, #selector(shareAction))])
            self.navigationItem.rightBarButtonItems = rightButtons
        default: break
        }
    }
    
    func openSubScreen() {
        let vc = PremiumMainController_MWP()
        vc.productBuy = .unlockFuncProduct
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func openFavAlert() {
        let style = switch viewModel.type {
        case .mods: "mod"
        case .items: "weapon"
        case .maps: "map"
        case .skins: "skin"
        default: ""
        }
        let alert = CustomAlertViewController(alertStyle: .itemsFavourite(style: style))
        alert.deleteHandler = {
            self.viewModel.toggleFavouriteStatus()
            self.itemsDeteilView.configureView(self.viewModel.model)
            self.modDeteilView.configureView(self.viewModel.model)
        }
        alert.modalPresentationStyle = .overFullScreen
        self.present(alert, animated: true)
    }
}

extension DeteilViewController: DeteilViewModelDelegate {
    func customAlert() {
        CompleteView.shared.showWithBlurEffect(completeStyle: .downloaded)
        self.itemsDeteilView.configureButtons(for: viewModel.checkIfFileExist())
        let index = isPad ? 1 : 0
        if viewModel.type == .mods {
            self.navigationItem.rightBarButtonItems?[0 + index].isEnabled = !viewModel.checkIfFileExist()
            self.navigationItem.rightBarButtonItems?[0 + index].customView?.alpha = viewModel.checkIfFileExist() ? 0.5 : 1
            self.navigationItem.rightBarButtonItems?[1 + index].isEnabled = viewModel.checkIfFileExist()
            self.navigationItem.rightBarButtonItems?[1 + index].customView?.alpha = viewModel.checkIfFileExist() ? 1 : 0.5
        } else if viewModel.type == .maps || viewModel.type == .items {
            self.navigationItem.rightBarButtonItems?[0 + index].isEnabled = viewModel.checkIfFileExist()
            self.navigationItem.rightBarButtonItems?[0 + index].customView?.alpha = viewModel.checkIfFileExist() ? 1 : 0.5
        }
    }
    
    func showActivityView(url: URL?) {
        guard let urlToShare = url else {
            print("downloaded URL is nil")
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [urlToShare], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
        
        // Представьте контроллер
        activityViewController.popoverPresentationController?.sourceView = viewModel.type == .mods ? self.navigationItem.rightBarButtonItem?.customView : itemsDeteilView.exportButton
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension DeteilViewController: PremiumMainController_MWPDelegate {
    func otherBought() {
        
    }
    
    func openApp_MWP() {
        
    }
    
    func funcBought() {
        self.modDeteilView.lockView(true)
        self.startEditAction()
    }
    
    func contentBought() {
        
    }
}

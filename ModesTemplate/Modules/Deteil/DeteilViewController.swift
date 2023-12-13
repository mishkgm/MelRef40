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
        view.shareButton.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        view.favouriteButton.addTarget(self, action: #selector(favouriteAction), for: .touchUpInside)
        return view
    }()
    
    lazy var modDeteilView: DeteilView = {
        var view = DeteilView()
         view.downloadButton.addTarget(self, action: #selector(downloadAction), for: .touchUpInside)
         view.shareButton.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
         view.startEditButton.addTarget(self, action: #selector(startEditAction), for: .touchUpInside)
         return view
    }()
    
    private var viewModel: DeteilViewModel
    
    init(model: DeteilModel, type: ContentType) {
        self.viewModel = DeteilViewModel(model: model, type: type)
        super.init(controllerType: .mods)
        switch type {
        case .mods:
            mainView = modDeteilView
        case .items, .skins:
            mainView = itemsDeteilView
        default: break
        }
        self.configureView()
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
        self.modDeteilView.configureButtons(for: viewModel.checkIfFileExist())
        self.modDeteilView.lockView(IAPManager_MWP.shared.productBought.contains(.unlockFuncProduct))
    }
    
    @objc func favouriteAction() {
        viewModel.toggleFavouriteStatus()
        itemsDeteilView.configureView(viewModel.model)
    }
    
    @objc func downloadAction() {
        guard checkConection() else { return }
        self.viewModel.downloadMod()
    }
    
    @objc func shareAction() {
        self.viewModel.shareMod()
    }
    
    @objc func startEditAction() {
        if !IAPManager_MWP.shared.productBought.contains(.unlockFuncProduct) {
            openSubScreen()
        } else {
            if let imageData = self.viewModel.model.image.pngData() {
                self.flowDelegate?.showDeteilEditor(imageData: imageData, title: self.viewModel.model.title)
            }
        }
    }
    
    func setupNavBar() {
        makeBackButton()
        switch viewModel.type {
        case .items: self.title = "Items"
        case .mods: self.title = "Mods"
        case .skins: self.title = "Skins"
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
}

extension DeteilViewController: DeteilViewModelDelegate {
    func customAlert() {
        CompleteView.shared.showWithBlurEffect(completeStyle: .downloaded)
        self.itemsDeteilView.configureButtons(for: viewModel.checkIfFileExist())
        self.modDeteilView.configureButtons(for: viewModel.checkIfFileExist())
    }
    
    func showActivityView(url: URL?) {
        guard let urlToShare = url else {
            print("downloaded URL is nil")
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [urlToShare], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
        
        // Представьте контроллер
        activityViewController.popoverPresentationController?.sourceView = viewModel.type == .mods ? modDeteilView.shareButton : itemsDeteilView.shareButton
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension DeteilViewController: PremiumMainController_MWPDelegate {
    func openApp_MWP() {
        
    }
    
    func funcBought() {
        self.modDeteilView.lockView(true)
        self.startEditAction()
    }
    
    func contentBought() {
        
    }
}

//
//  ItemsViewController.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 26.11.2023.
//

import Foundation
import UIKit
import SnapKit

enum ItemsType: String {
    case weapons = "Weapons"
    case skins = "Skins"
    case maps = "Maps"
}

final class ItemsViewController: BaseViewController {
    
    lazy var mainView: ItemsView = {
        var view = ItemsView()
        view.collectionView.dataSource = self
        view.collectionView.delegate = self
        view.bannerView.subDelegate = self
        view.filterList.delegate = self
        return view
    }()
    
    lazy var viewModel: ItemsViewModel = {
        var type: ContentType = .maps
        switch self.controllerType {
        case .maps: type = .maps
        case .skins: type = .skins
        case .weapons: type = .items
        default: break
        }
        var model = ItemsViewModel(contentType: type, delegate: self)
        return model
    }()
    
    init(controllerType: ControllersType, isFavouriteSetup: Bool = false) {
        super.init(controllerType: controllerType)
        self.viewModel.isFavouriteSetup = isFavouriteSetup
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
        let btn = self.createButton(config: [(AppConfig.Icons.filterIcon, #selector(openFilter))])
        self.navigationItem.rightBarButtonItems = btn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateContent()
    }
    
    @objc func openFilter() {
        self.mainView.filterShow()
        var currentFilter = self.viewModel.contentType == .items ? FilterMods.items.rawValue : FilterMods.skins.rawValue
        if viewModel.contentType == .maps {
            currentFilter = ""
        }
        self.mainView.filterList.openСategoryPicker(items: FilterMods.allCases.map({ $0.rawValue }), isCurrent: viewModel.isFavouriteSetup ? FilterMods.favourite.rawValue : currentFilter)
        self.navigationItem.rightBarButtonItems = self.createButton(config: [(AppConfig.Icons.crossButton, #selector(hideFilter))])
    }
    
    @objc func hideFilter() {
        self.mainView.filterHide()
        self.navigationItem.rightBarButtonItems = self.createButton(config: [(AppConfig.Icons.filterIcon, #selector(openFilter))])
    }
}

extension ItemsViewController: DropDownMenuDelegate {
    func cellDidTap(text: String?) {
        switch FilterMods(rawValue: text ?? "") ?? .favourite {
        case .items:
            if viewModel.contentType == .items {
                self.mainView.noFoundLabel.isHidden = true
                self.viewModel.isFavouriteSetup = false
                self.viewModel.updateContent()
            } else {
                self.flowDelegate?.navigateToController(filter: .items)
            }
        case .mods:
            self.flowDelegate?.navigateToController(filter: FilterMods(rawValue: text ?? "") ?? .mods)
        case .skins:
            if viewModel.contentType == .skins {
                self.mainView.noFoundLabel.isHidden = true
                self.viewModel.isFavouriteSetup = false
                self.viewModel.updateContent()
            } else {
                self.flowDelegate?.navigateToController(filter: .skins)
            }
        case .favourite:
            self.viewModel.isFavouriteSetup = true
            self.viewModel.updateContent()
        }
        self.hideFilter()
    }
}

extension ItemsViewController: BaseViewModelDelegate {
    func isEmtyCollection(_ isEmty: Bool) {
        self.mainView.noFoundLabel.isHidden = !isEmty
    }
    
    func reloadData() {
        mainView.collectionView.reloadData()
    }
    
    func showCustomAlert(style: CompleteStyle) {
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        CompleteView.shared.showWithBlurEffect(completeStyle: style)
    }
}

extension ItemsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.contentType {
            // Skins
        case .skins:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkinsCollectionViewCell.cellIdentifier(), for: indexPath) as? SkinsCollectionViewCell else { return UICollectionViewCell() }
            cell.favouriteButton.tag = indexPath.row
            cell.saveButton.tag = indexPath.row
            cell.favouriteComplition = { [weak self] index in
                self?.showFavouriteAlert(index: index)
            }
            cell.saveComlition = { [weak self] index in
                self?.downloadMod(index: index)
            }
            cell.configureCell(item: viewModel.model[indexPath.row])
            viewModel.downloadImage(index: indexPath.row, imageView: cell.imageView)
            return cell
            // Weapons + Maps
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemsCollectionViewCell.cellIdentifier(), for: indexPath) as? ItemsCollectionViewCell else { return UICollectionViewCell() }
            cell.favouriteButton.tag = indexPath.row
            cell.favouriteComplition = { [weak self] index in
                self?.showFavouriteAlert(index: index)
            }
            cell.configureCell(item: viewModel.model[indexPath.row])
            viewModel.downloadImage(index: indexPath.row, imageView: cell.mainImage)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.model[indexPath.row]
        guard let data = item.imageData, let image = UIImage(data: data) else { return }
        self.flowDelegate?.showDeteil(item: DeteilModel(title: item.title, description: item.description, image: image, downloadPath: item.downloadPath, isFavourite: item.isFavourite, realmKey: item.realmKey), type: viewModel.contentType)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return isPad ? CGSize(width: screenSize.width/3 - 48, height: screenSize.height / 3.94) : CGSize(width: screenSize.width / 2 - 25, height: screenSize.height / 3.65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return isPad ? UIEdgeInsets(top: 20, left: 60, bottom: 0, right: 60) : UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
    }
}

private extension ItemsViewController {
    func showFavouriteAlert(index: Int) {
        guard self.viewModel.model[index].isFavourite else {
            self.viewModel.toggleFavouriteStatus(index: index)
            self.mainView.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            return
        }
        let style = switch viewModel.contentType {
        case .maps: "map"
        case .mods: "mod"
        case .items: "item"
        case .skins: "skin"
        default: ""
        }
        let alert = CustomAlertViewController(alertStyle: .itemsFavourite(style: style))
        alert.modalPresentationStyle = .overCurrentContext
        alert.deleteHandler = { [weak self] in
            self?.viewModel.toggleFavouriteStatus(index: index)
            self?.mainView.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
        self.present(alert, animated: true)
    }
    
    func downloadMod(index: Int) {
        guard checkConection() else { return }
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.viewModel.downloadMod(index: index)
    }
}

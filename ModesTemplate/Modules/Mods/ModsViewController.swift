//
//  ModsViewController.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 26.11.2023.
//

import Foundation
import UIKit
import SDWebImage

enum FilterMods: String, CaseIterable {
    case mods = "Mods"
    case skins = "Skins"
    case items = "Items"
    case favourite = "Favorite"
    
    var navigateIndex: Int {
        switch self {
        case .items: return 4
        case .skins: return 2
        case .mods: return 0
        default: return 0
        }
    }
}

final class ModsViewController: BaseViewController {
    
    lazy var mainView: ModsView = {
        let view = ModsView()
        view.modsCollection.delegate = self
        view.modsCollection.dataSource = self
        view.categoryCollection.delegate = self
        view.categoryCollection.dataSource = self
        view.searchBar.delegate = self
        view.closeButton.addTarget(self, action: #selector(closeSearchBar), for: .touchUpInside)
        let closeGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        closeGesture.cancelsTouchesInView = false
        view.searchBarConteiner.addGestureRecognizer(closeGesture)
        view.sigestList.delegate = self
        view.filterList.delegate = self
        view.bannerView.subDelegate = self
        return view
    }()
    
    lazy var viewModel: ModsViewModel = {
        var model = ModsViewModel(contentType: .mods, delegate: self)
        return model
    }()
    
    private var dropDownModel: CurrentState = .common
    
    init(controllerType: ControllersType, isFavouriteSetup: Bool = false) {
        super.init(controllerType: controllerType)
        if isFavouriteSetup {
            self.viewModel.setCurrentState(state: .favourite)
            mainView.favouriteViewSetup()
        }
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
        viewModel.updateContent()
        self.hideFilter()
        self.mainView.modsCollection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if viewModel.currentState != .favourite {
            self.closeSearchBar()
        }
    }
}

extension ModsViewController: DropDownMenuDelegate {
    func cellDidTap(text: String?) {
        DispatchQueue.main.async {
            switch self.mainView.searchBar.isHidden {
            case false:
                let index = self.viewModel.getModelFor(state: .all).firstIndex(where: { $0.title == text })
                self.showDeteilViewController(index: index ?? 0)
            case true:
                switch FilterMods(rawValue: text ?? "") ?? .favourite {
                case .items,.skins:
                    self.flowDelegate?.navigateToController(filter: FilterMods(rawValue: text ?? "") ?? .mods)
                case .mods:
                    self.dropDownModel = .common
                    self.reloadData()
                    self.viewModel.setCurrentState(state: .common)
                    self.hideFilter()
                case .favourite:
                    self.dropDownModel = .favourite
                    self.reloadData()
                    self.viewModel.setCurrentState(state: .favourite)
                    self.hideFilter()
                }
            }
        }
    }
}

extension ModsViewController: BaseViewModelDelegate {
    func isEmtyCollection(_ isEmty: Bool) {
        self.emptyCollection?(isEmty)
    }
    
    func reloadData() {
        self.mainView.noFoundLabel.isHidden = viewModel.currentModel().count != 0
        self.mainView.categoryCollection.reloadData()
        self.mainView.modsCollection.reloadData()
    }
}

// MARK: - CollectionView
extension ModsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView == mainView.modsCollection {
        case true: return viewModel.getModelFor(state: dropDownModel).count
        case false: return viewModel.categoryModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView == mainView.modsCollection {
        case true:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ModsCollectionViewCell.cellIdentifier(), for: indexPath) as? ModsCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(item: viewModel.getModelFor(state: dropDownModel)[indexPath.row])
            cell.favouriteButton.tag = indexPath.row
            cell.favouriteComplition = { [weak self] index in
                self?.showFavouriteAlert(index: index)
            }
            viewModel.downloadImage(key: viewModel.getModelFor(state: dropDownModel)[indexPath.row].realmKey, imageView: cell.mainImage)
            return cell
        case false:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesViewCell.cellIdentifier(), for: indexPath) as? CategoriesViewCell else { return UICollectionViewCell() }
            let isLoked = indexPath.row == 0 && !IAPManager_MWP.shared.productBought.contains(.unlockContentProduct)
            cell.configureCell(item: viewModel.categoryModel[indexPath.row].title, isLoked: isLoked, isSelected: viewModel.categoryModel[indexPath.row].title == (viewModel.currentCategory?.title ?? ""))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView == mainView.modsCollection {
        case true:
            self.showDeteilViewController(index: indexPath.row)
        case false:
            if indexPath.row == 0 && !IAPManager_MWP.shared.productBought.contains(.unlockContentProduct) {
                self.openSub(style: .unlockContentProduct)
            } else {
                self.viewModel.selectCategory(category: viewModel.categoryModel[indexPath.row])
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView == mainView.modsCollection {
        case true: return isPad ? CGSize(width: screenSize.width/3 - 48, height: screenSize.height / 3.94) : CGSize(width: screenSize.width / 2 - 25, height: screenSize.height / 3.65)
        case false: return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height - 8)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView == mainView.modsCollection {
        case true:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case false:
            return UIEdgeInsets(top: 0, left: isPad ? 60 : 20, bottom: 0, right: isPad ? 60 : 20)
        }
    }
}

extension ModsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.setCurrentState(state: .search(text: searchText))
        if !searchText.replacingOccurrences(of: " ", with: "").isEmpty {
            self.mainView.sigestList.openСategoryPicker(items: viewModel.getModelFor(state: .search(text: searchText)).map({ $0.title }))
        } else {
            self.mainView.sigestList.openСategoryPicker(items: viewModel.currentModel().prefix(0).map({ $0.title }))
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.mainView.showCloseButton()
        self.mainView.makeNewPlacehorlder(text: "")
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.reloadData()
        self.mainView.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

    }
}

private extension ModsViewController {
    
    @objc func openSearch() {
        self.navigationController?.navigationBar.isHidden = true
        self.hideFilter()
        self.mainView.searchSetup()
    }
    
    @objc func closeSearchBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.mainView.hideSearch()
        self.viewModel.setCurrentState(state: .common)
        self.mainView.makeNewPlacehorlder(text: "Search")
    }
    
    @objc func openFilter() {
        self.mainView.filterShow()
        let curretFilter = viewModel.currentState == .favourite ? FilterMods.favourite : FilterMods.mods
        self.mainView.filterList.openСategoryPicker(items: FilterMods.allCases.map({ $0.rawValue }), isCurrent: curretFilter.rawValue)
        self.navigationItem.rightBarButtonItems = self.createButton(config: [(AppConfig.Icons.crossButton, #selector(hideFilter)), (AppConfig.Icons.searchImage, #selector(openSearch))])
    }
    
    @objc func hideFilter() {
        self.mainView.filterHide()
        self.navigationItem.rightBarButtonItems = self.createButton(config: [(AppConfig.Icons.filterIcon, #selector(openFilter)), (AppConfig.Icons.searchImage, #selector(openSearch))])
    }
    
    func setupNavBar() {
        let btn = self.createButton(config: [(AppConfig.Icons.filterIcon, #selector(openFilter)), (AppConfig.Icons.searchImage, #selector(openSearch))])
        self.navigationItem.rightBarButtonItems = btn
    }
    
    func showDeteilViewController(index: Int, state: CurrentState = .common) {
        let item = viewModel.getModelFor(state: state)[index]
        
        if let data = item.imageData {
            self.flowDelegate?.showDeteil(item: DeteilModel(title: item.title, description: item.description, image: UIImage(data: data), downloadPath: item.downloadPath, isFavourite: item.isFavourite, realmKey: item.realmKey, imagePath: item.imagePath), type: viewModel.contentType)
        } else {
            self.flowDelegate?.showDeteil(item: DeteilModel(title: item.title, description: item.description, image: nil, downloadPath: item.downloadPath, isFavourite: item.isFavourite, realmKey: item.realmKey, imagePath: item.imagePath), type: viewModel.contentType)
        }
    }
    
    func showFavouriteAlert(index: Int) {
        guard self.viewModel.getModelFor(state: viewModel.currentState)[index].isFavourite else {
            self.viewModel.togleFavouriteStatus(for: index)
            self.mainView.modsCollection.reloadItems(at: [IndexPath(row: index, section: 0)])
            return
        }
        let alert = CustomAlertViewController(alertStyle: .itemsFavourite(style: "mod"))
        alert.modalPresentationStyle = .overCurrentContext
        alert.deleteHandler = { [weak self] in
            self?.viewModel.togleFavouriteStatus(for: index)
            self?.mainView.modsCollection.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
        self.present(alert, animated: true)
    }
}

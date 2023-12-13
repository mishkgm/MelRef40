//
//  ModsViewController.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 26.11.2023.
//

import Foundation
import UIKit
import SDWebImage

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
        view.bannerView.subDelegate = self
        return view
    }()
    
    lazy var viewModel: ModsViewModel = {
        var model = ModsViewModel(contentType: .mods, delegate: self)
        return model
    }()
    
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
        viewModel.updateContent()
        setupNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if viewModel.currentState != .favourite {
            self.closeSearchBar()
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

extension ModsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView == mainView.modsCollection {
        case true: return viewModel.currentModel().count
        case false: return viewModel.categoryModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView == mainView.modsCollection {
        case true:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ModsCollectionViewCell.cellIdentifier(), for: indexPath) as? ModsCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(item: viewModel.currentModel()[indexPath.row], isFavouriteSetup: false)
            cell.favouriteButton.tag = indexPath.row
            cell.favouriteComplition = { [weak self] index in
                self?.showFavouriteAlert(index: index)
            }
            viewModel.downloadImage(key: viewModel.currentModel()[indexPath.row].realmKey, imageView: cell.mainImage)
            return cell
        case false:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesViewCell.cellIdentifier(), for: indexPath) as? CategoriesViewCell else { return UICollectionViewCell() }
            cell.configureCell(item: viewModel.categoryModel[indexPath.row].title, isLoked: false, isSelected: viewModel.categoryModel[indexPath.row].title == (viewModel.currentCategory?.title ?? ""))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView == mainView.modsCollection {
        case true:
            self.showDeteilViewController(index: indexPath.row)
        case false:
            self.viewModel.selectCategory(category: viewModel.categoryModel[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView == mainView.modsCollection {
        case true: return isPad ? CGSize(width: screenSize.width - 120, height: screenSize.height / 5.5) :
            CGSize(width: screenSize.width - 40, height: screenSize.height / 5.5)
        case false: return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height - 8)
        }
    }
}

extension ModsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.replacingOccurrences(of: " ", with: "").isEmpty {
            self.viewModel.setCurrentState(state: .search(text: searchText))
        } else {
            self.viewModel.setCurrentState(state: .all)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.mainView.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.viewModel.setCurrentState(state: .common)
        self.closeSearchBar()
    }
}

private extension ModsViewController {
    
    @objc func openSearch() {
        self.navigationController?.navigationBar.isHidden = true
        self.mainView.searchSetup()
        self.mainView.searchBar.becomeFirstResponder()
    }
    
    @objc func closeSearchBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.mainView.hideSearch()
    }
    
    func setupNavBar() {
        let btn = self.createButton(image: AppConfig.Icons.searchImage, action: #selector(openSearch))
        self.navigationItem.rightBarButtonItem = btn
    }
    
    func showDeteilViewController(index: Int) {
        let item = viewModel.currentModel()[index]
        guard let imageData = item.imageData, let image = UIImage(data: imageData) else { return }
        self.flowDelegate?.showDeteil(item: DeteilModel(title: item.title, description: item.description, image: image, downloadPath: item.downloadPath), type: viewModel.contentType)
    }
    
    func showFavouriteAlert(index: Int) {
        guard self.viewModel.currentModel()[index].isFavourite else {
            self.viewModel.togleFavouriteStatus(for: index)
            self.mainView.modsCollection.reloadItems(at: [IndexPath(row: index, section: 0)])
            return
        }
        let alert = CustomAlertViewController(alertStyle: .itemsFavourite)
        alert.modalPresentationStyle = .overCurrentContext
        alert.deleteHandler = { [weak self] in
            self?.viewModel.togleFavouriteStatus(for: index)
            self?.mainView.modsCollection.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
        self.present(alert, animated: true)
    }
}

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
    case items = "Items"
    case skins = "Skins"
}

final class ItemsViewController: BaseViewController {
    
    lazy var mainView: ItemsView = {
        var view = ItemsView()
        view.collectionView.dataSource = self
        view.collectionView.delegate = self
        view.bannerView.subDelegate = self
        return view
    }()
    
    lazy var viewModel: ItemsViewModel = {
        let type = self.controllerType == .items ? ContentType.items : ContentType.skins
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateContent()
    }
}

extension ItemsViewController: BaseViewModelDelegate {
    func isEmtyCollection(_ isEmty: Bool) {
        self.emptyCollection?(isEmty)
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
        case .items:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemsCollectionViewCell.cellIdentifier(), for: indexPath) as? ItemsCollectionViewCell else { return UICollectionViewCell() }
            cell.favouriteButton.tag = indexPath.row
            cell.favouriteComplition = { [weak self] index in
                self?.showFavouriteAlert(index: index)
            }
            cell.configureCell(item: viewModel.model[indexPath.row])
            viewModel.downloadImage(index: indexPath.row, imageView: cell.imageView)
            return cell
        default:
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
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.model[indexPath.row]
        guard let data = item.imageData, let image = UIImage(data: data) else { return }
        self.flowDelegate?.showDeteil(item: DeteilModel(title: item.title, description: item.description, image: image, downloadPath: item.downloadPath, isFavourite: item.isFavourite, realmKey: item.realmKey), type: viewModel.contentType)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel.contentType {
        case .items:
            return isPad ? CGSize(width: screenSize.width / 2 - 70, height: screenSize.height / 4.1) : CGSize(width: screenSize.width / 2 - 25, height: screenSize.height / 3.6)
        default:
            return isPad ? CGSize(width: screenSize.width - 120, height: screenSize.height / 6) : CGSize(width: screenSize.width - 32, height: screenSize.height / 6.6)
        }
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
        let alert = CustomAlertViewController(alertStyle: .itemsFavourite)
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

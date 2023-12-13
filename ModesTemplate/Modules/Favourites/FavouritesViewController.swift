//
//  FavouritesViewController.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 27.11.2023.
//

import Foundation
import UIKit

enum FavouriteType: String, CaseIterable {
    case items = "Items"
    case skins = "Skins"
    case mods = "Mods"
    
    var controller: BaseViewController {
        switch self {
        case .items:
            let vc = ItemsViewController(controllerType: .weapons, isFavouriteSetup: true)
            return vc
        case .skins:
            let vc = ItemsViewController(controllerType: .skins, isFavouriteSetup: true)
            return vc
        case .mods:
            let vc = ModsViewController(controllerType: .mods, isFavouriteSetup: true)
            return vc
        }
    }
    
    var title: String {
        switch self {
        case .items: return localizedString(forKey: "items")
        case .skins: return localizedString(forKey: "skins")
        case .mods: return localizedString(forKey: "mods")
        }
    }
}

final class FavouritesViewController: BaseViewController {
    
    lazy var mainView: FavouritesView = {
       var view = FavouritesView()
        view.selectCollection.dataSource = self
        view.selectCollection.delegate = self
        return view
    }()
    
    private(set) var currentType: FavouriteType = .items {
        didSet {
            changeCurrentType()
            mainView.selectCollection.isHidden = true
            mainView.selectCollection.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentType = .mods
        createFilterButton()
    }
}

extension FavouritesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        FavouriteType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouriteSelectorCell.cellIdentifier(), for: indexPath) as? FavouriteSelectorCell else { return UICollectionViewCell() }
        cell.titleLabel.text = FavouriteType.allCases[indexPath.row].rawValue
        cell.selecteCheckMark.isHidden = currentType != FavouriteType.allCases[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentType = FavouriteType.allCases[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: collectionView.frame.height / 3 - 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
    }
}

private extension FavouritesViewController {
    
    func createFilterButton() {
        self.navigationItem.rightBarButtonItems = self.createButton(config: [(AppConfig.Icons.favoriteFilterIcon, action: #selector(filterButtonTapped))])
    }
    
    @objc func filterButtonTapped() {
        self.mainView.selectCollection.isHidden.toggle()
    }
    
    func changeCurrentType() {
        let vc = currentType.controller
        vc.flowDelegate = self.flowDelegate
        vc.emptyCollection = { [weak self] isEmty in
            self?.mainView.conteiner.isHidden = isEmty
            self?.mainView.bannerView.isHidden = !isEmty
            self?.mainView.emtyView.isHidden = !isEmty
        }
        addChild(vc)
        
        self.mainView.conteiner.addSubview(vc.view)
        vc.view.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        vc.didMove(toParent: self)
    }
}

//
//  ModsView.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 26.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class ModsView: BaseView {
    
    lazy var searchBarConteiner: UIView = {
       var view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var noFoundLabel: UILabel = {
       var label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.text = "No found results"
        label.font = UIFont(size: 20)
        return label
    }()
    
    lazy var searchBar: UISearchBar = {
       var searchBar = UISearchBar()
        searchBar.backgroundColor = .clear
        searchBar.layer.cornerRadius = 10
        searchBar.layer.masksToBounds = true
        searchBar.barTintColor = UIColor(hex: "#989898").withAlphaComponent(0.8)
        searchBar.isHidden = true
        searchBar.showsCancelButton = false
        return searchBar
    }()
    
    lazy var closeButton: UIButton = {
       var button = UIButton()
        button.setImage(AppConfig.Icons.crossButton, for: .normal)
        button.tintColor = UIColor(hex: "#989898").withAlphaComponent(0.8)
        return button
    }()
    
    lazy var chevronImageView: UIImageView = {
       var image = UIImageView()
        image.contentMode = .scaleToFill
        image.image = AppConfig.Icons.categoryChevron
        return image
    }()
    
    lazy var categoryCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.register(CategoriesViewCell.self)
        return view
    }()
    
    lazy var modsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.register(ModsCollectionViewCell.self)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        categoryCollection.layer.sublayers?.removeAll(where: { $0.isKind(of: CAGradientLayer.self )})
//        categoryCollection.setGradientBorder(width: 1, colors: [AppConfig.Colors.cellBorderColor, UIColor(hex: "#42535A")])
//        categoryCollection.layoutIfNeeded()
    }
    
    override func configureView() {
        super.configureView()
        addSubview(searchBarConteiner)
        searchBarConteiner.addSubview(noFoundLabel)
        addSubview(categoryCollection)
        addSubview(modsCollection)
        addSubview(searchBar)
        searchBar.addSubview(closeButton)
        configureSearchBar()
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        searchBarConteiner.snp.remakeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(0)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview()
        }
        noFoundLabel.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        categoryCollection.snp.remakeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(20)
            make.trailing.leading.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        modsCollection.snp.remakeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(isPad ? 110 : 90)
            make.trailing.leading.equalToSuperview().inset(isPad ? 60 : 20)
            make.bottom.equalToSuperview()
        }
    }
    
    func searchSetup() {
        self.categoryCollection.isHidden = true
        self.searchBar.isHidden = false
        self.makeConstraintsForSearch()
    }
    
    func hideSearch() {
        self.searchBar.text = nil
        self.searchBar.isHidden = true
        self.categoryCollection.isHidden = false
        self.endEditing(true)
        self.makeConstraints()
    }
    
    func favouriteViewSetup() {
        categoryCollection.isHidden = true
        modsCollection.snp.remakeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(20)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

private extension ModsView {
    func makeConstraintsForSearch() {
        self.searchBar.snp.remakeConstraints { make in
            make.top.equalTo(self.bannerView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(isPad ? 50 : 10)
        }
        self.modsCollection.snp.remakeConstraints { make in
            make.top.equalTo(self.searchBar.snp.bottom).offset(5)
            make.trailing.leading.equalToSuperview().inset(isPad ? 60 : 20)
            make.bottom.equalToSuperview()
        }
        self.closeButton.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func configureSearchBar() {
        
        if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
            
            var placeholderAttributes = [NSAttributedString.Key: AnyObject]()
            placeholderAttributes[.foregroundColor] = UIColor(hex: "#989898").withAlphaComponent(0.8) // Укажите нужный цвет здесь
            placeholderAttributes[.font] = UIFont(size: 16)
            
            let attributedPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes)
            searchField.attributedPlaceholder = attributedPlaceholder
            
            // Замените "searchImage" на имя вашего изображения для значка "Поиск"
            if let searchImage = UIImage(named: "search") {
                searchField.leftView = UIImageView(image: searchImage)
                searchField.leftView?.tintColor = UIColor(hex: "#989898").withAlphaComponent(0.8)
            }
        }
        searchBar.backgroundImage = UIImage() // Удаляет задний фон для UISearchBar
        if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
            searchField.background = UIImage() // Удаляет задний фон для UITextField
            searchField.backgroundColor = .clear
        }
    }
}

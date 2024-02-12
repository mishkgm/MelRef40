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
        label.text = "There’s nothing here yet"
        label.font = UIFont(size: 20)
        return label
    }()
    
    lazy var searchBar: UISearchBar = {
       var searchBar = UISearchBar()
        searchBar.backgroundColor = .clear
        searchBar.layer.cornerRadius = 10
        searchBar.layer.masksToBounds = true
        searchBar.barTintColor = UIColor(hex: "#989898").withAlphaComponent(0.8)
        searchBar.searchTextField.textColor = .white
        searchBar.showsCancelButton = false
        return searchBar
    }()
    
    lazy var sigestList: DropDownMenu = {
        var view = DropDownMenu(isCentrallSetup: false)
        return view
    }()
    
    lazy var filterList: FilterMenu = {
        var filter = FilterMenu()
        filter.isHidden = true
        return filter
    }()
    
    lazy var closeButton: UIButton = {
       var button = UIButton()
        button.layer.cornerRadius = 12
        button.setImage(AppConfig.Icons.crossButton, for: .normal)
        button.tintColor = UIColor(hex: "#989898").withAlphaComponent(0.8)
        button.backgroundColor = AppConfig.Colors.cellBackgroundColor
        button.layer.borderWidth = 0.5
        button.layer.borderColor = AppConfig.Colors.cellBorderColor.cgColor
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
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
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
        var coof = 0
        if sigestList.items.count <= 4 {
            coof = sigestList.items.count
        } else {
            coof = 4
        }
        sigestList.snp.remakeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(isPad ? 60 : 20)
            make.height.equalTo(isPad ? coof * 70 : coof * 48)
        }
    }
    
    override func configureView() {
        super.configureView()
        addSubview(searchBarConteiner)
        addSubview(noFoundLabel)
        addSubview(categoryCollection)
        addSubview(modsCollection)
        addSubview(searchBar)
        addSubview(searchBar)
        addSubview(closeButton)
        addSubview(sigestList)
        addSubview(filterList)
        configureSearchBar()
        self.sigestList.isHidden = true
        self.searchBar.isHidden = true
        self.closeButton.isHidden = true
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        searchBarConteiner.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.leading.trailing.equalToSuperview()
//            make.trailing.equalTo(closeButton.snp.leading).inset(12)
            make.height.equalToSuperview()
        }
        noFoundLabel.snp.remakeConstraints { make in
            make.center.equalToSuperview()
        }
        filterList.snp.remakeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(-5)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalToSuperview().multipliedBy(0.33)
        }
        categoryCollection.snp.remakeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(isPad ? 100 : 60)
        }
        modsCollection.snp.remakeConstraints { make in
            make.top.equalTo(categoryCollection.snp.bottom).offset(15)
            make.trailing.leading.equalToSuperview().inset(isPad ? 60 : 20)
            make.bottom.equalToSuperview()
        }
        sigestList.snp.remakeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(isPad ? 60 : 20)
//            make.height.equalTo(300)
        }
        self.searchBar.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(45)
            make.leading.trailing.equalToSuperview().inset(isPad ? 50 : 10)
        }
    }
    
    func filterShow() {
        self.filterList.isHidden = false
    }
    
    func filterHide() {
        self.filterList.isHidden = true
    }
    
    func searchSetup() {
        self.sigestList.isHidden = false
        self.searchBar.isHidden = false
        bannerView.snp.remakeConstraints { make in
            make.height.equalTo(0)
        }
        categoryCollection.snp.remakeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(isPad ? 100 : 60)
        }
    }
    
    func hideSearch() {
        self.searchBar.text = nil
        self.sigestList.isHidden = true
        self.searchBar.isHidden = true
        self.closeButton.isHidden = true
        self.sigestList.categoryCollection.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        self.endEditing(true)
        self.makeConstraints()
        sigestList.items.removeAll()
        sigestList.snp.remakeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(isPad ? 60 : 20)
            make.height.equalTo(0)
        }
    }
    
    func showCloseButton() {
        self.makeConstraintsForSearch()
    }
    
    func favouriteViewSetup() {
        categoryCollection.isHidden = true
        modsCollection.snp.remakeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(20)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func makeNewPlacehorlder(text: String) {
        if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
            var placeholderAttributes = [NSAttributedString.Key: AnyObject]()
            placeholderAttributes[.foregroundColor] = UIColor(hex: "#989898").withAlphaComponent(0.8) // Укажите нужный цвет здесь
            placeholderAttributes[.font] = UIFont(size: 16)
            
            let attributedPlaceholder = NSAttributedString(string: text, attributes: placeholderAttributes)
            searchField.attributedPlaceholder = attributedPlaceholder
        }
    }
}

private extension ModsView {
    func makeConstraintsForSearch() {
        self.closeButton.isHidden = false
        self.searchBar.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(45)
            make.leading.equalToSuperview().inset(isPad ? 50 : 10)
            make.trailing.equalTo(closeButton.snp.leading).offset(-5)
        }
        self.closeButton.snp.remakeConstraints { make in
            make.centerY.equalTo(searchBar.snp.centerY)
            make.trailing.equalToSuperview().inset(isPad ? 50 : 10)
            make.height.equalTo(36)
            make.width.equalTo(closeButton.snp.height)
        }
    }
    
    func configureSearchBar() {
        
        makeNewPlacehorlder(text: "Search")
        if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
            
            searchField.tintColor = .white
            // Замените "searchImage" на имя вашего изображения для значка "Поиск"
            if let searchImage = UIImage(named: "search") {
                searchField.leftView = UIImageView(image: searchImage)
                searchField.leftView?.tintColor = .white
            }
            
            if let clearButton = searchField.value(forKeyPath: "_clearButton") as? UIButton {
                clearButton.setImage(AppConfig.Icons.crossButton, for: .normal)
            } // Показывать кнопку только при редактировании текста
            
        }
        searchBar.backgroundImage = UIImage() // Удаляет задний фон для UISearchBar
        if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
            searchField.background = UIImage() // Удаляет задний фон для UITextField
            searchField.backgroundColor = UIColor(hex: "#456D56")
            searchField.layer.cornerRadius = 12
            searchField.layer.borderWidth = 0.5
            searchField.layer.borderColor = AppConfig.Colors.cellBorderColor.cgColor
        }
    }
}

//
//  SkinsCollectionView.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 26.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class SkinsCollectionViewCell: BaseCollectionViewCell {
    
   lazy var saveButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(AppConfig.Icons.saveicon, for: .normal)
       button.tintColor = .white
        return button
    }()
    
    lazy var favouriteButton: UIButton = {
        var button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(AppConfig.Icons.favoritesEmpty, for: .normal)
        return button
    }()
    
    lazy var imageView: UIImageView = {
       var view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = AppConfig.Colors.imagesBackgoundColor
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont(size: 14, type: .bold)
        label.textColor = AppConfig.Colors.titlesColor
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(size: 14, type: .regular)
        label.textColor = AppConfig.Colors.descriptionsColor
        label.numberOfLines = 2
        label.isHidden = true
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    override func configureView() {
        super.configureView()
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
    }
    
    override func makeConstraints() {
        imageView.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(bounds.width / 2)
        }
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(imageView.snp.leading).offset(-5)
        }
        
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.addArrangedSubview(favouriteButton)
        buttonStackView.addArrangedSubview(saveButton)
        
        addSubview(buttonStackView)

        buttonStackView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(isPad
                            ? CGSize(width: 80 * 1.8, height: 28 * 1.8)
                            : CGSize(width: 80, height: 28))
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func configureCell(item: ItemsModel) {
        if let data = item.imageData, let image = UIImage(data: data) {
            self.imageView.image = image
        }
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        isFavourite = item.isFavourite
        favouriteButton.tintColor = item.isFavourite ? AppConfig.Colors.buttonsColors : .white
        favouriteButton.setImage(item.isFavourite ? AppConfig.Icons.favoritesFill : AppConfig.Icons.favoritesEmpty, for: .normal)
    }
    
    @objc func saveButtonTapped() {
        saveComlition?(saveButton.tag)
    }
    
    @objc func favouriteButtonTapped() {
        self.isFavourite.toggle()
        togleFavouriteStatus()
    }
    
    func togleFavouriteStatus() {
//        switch isFavourite {
//        case true:
//            self.favouriteButton.tintColor = AppConfig.Colors.buttonsColors
//            self.favouriteButton.setImage(AppConfig.Icons.favoritesFill, for: .normal)
//        case false:
//            self.favouriteButton.tintColor = .white
//            self.favouriteButton.setImage(AppConfig.Icons.favoritesEmpty, for: .normal)
//        }
        self.favouriteComplition?(favouriteButton.tag)
    }
}

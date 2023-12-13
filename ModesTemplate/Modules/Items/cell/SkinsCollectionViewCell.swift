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
    
    lazy var saveButton: CustomButton = {
        var button = CustomButton()
        button.layer.cornerRadius = 12
        button.tintColor = .white
        button.setImage(AppConfig.Icons.saveicon)
        button.backgroundColor = AppConfig.Colors.imagesBackgoundColor
        return button
    }()
    
    lazy var favouriteButton: CustomButton = {
        var button = CustomButton()
        button.layer.cornerRadius = 12
        button.tintColor = .white
        button.setImage(AppConfig.Icons.favoritesEmpty)
        button.backgroundColor = AppConfig.Colors.imagesBackgoundColor
        return button
    }()
    
    lazy var imageView: UIImageView = {
       var view = UIImageView()
        view.layer.cornerRadius = 12
        view.contentMode = .scaleAspectFit
        view.backgroundColor = AppConfig.Colors.imagesBackgoundColor
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont(size: 16, type: .regular)
        label.textColor = AppConfig.Colors.titlesColor
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(size: 14, type: .regular)
        label.textColor = AppConfig.Colors.descriptionsColor
        label.numberOfLines = 1
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
            make.top.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalToSuperview().multipliedBy(0.38)
        }
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.trailing.leading.equalToSuperview().inset(12)
        }
        descriptionLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.trailing.leading.equalToSuperview().inset(12)
        }
        
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.addArrangedSubview(favouriteButton)
        buttonStackView.addArrangedSubview(saveButton)
        buttonStackView.spacing = 8
        
        addSubview(buttonStackView)

        buttonStackView.snp.remakeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            make.leading.bottom.trailing.equalToSuperview().inset(12)
            make.size.equalTo(isPad
                            ? CGSize(width: 80 * 1.8, height: 28 * 1.8)
                            : CGSize(width: 80, height: 28))
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
        favouriteButton.setImage(item.isFavourite ? AppConfig.Icons.favoritesFill : AppConfig.Icons.favoritesEmpty)
    }
    
    @objc func saveButtonTapped() {
        saveComlition?(saveButton.tag)
    }
    
    @objc func favouriteButtonTapped() {
        self.isFavourite.toggle()
        togleFavouriteStatus()
    }
    
    func togleFavouriteStatus() {
        self.favouriteComplition?(favouriteButton.tag)
    }
}

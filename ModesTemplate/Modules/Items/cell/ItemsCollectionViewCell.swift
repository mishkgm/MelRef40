//
//  ModsCollectionViewCell.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 27.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class ItemsCollectionViewCell: BaseCollectionViewCell {

    lazy var mainImage: UIImageView = {
       var image = UIImageView()
        image.layer.cornerRadius = 12
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        image.backgroundColor = AppConfig.Colors.imagesBackgoundColor
        return image
    }()
    
    lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont(size: 16, type: .regular)
        label.textColor = AppConfig.Colors.titlesColor
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
       var label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont(size: 14, type: .regular)
        label.textColor = AppConfig.Colors.descriptionsColor
        return label
    }()
    
    lazy var favouriteButton: CustomButton = {
       var button = CustomButton()
        button.layer.cornerRadius = 12
        button.setImage(AppConfig.Icons.favoritesEmpty)
        button.setTitle("Favorite", for: .normal)
        button.titleLabel?.font = UIFont(size: 14)
        button.backgroundColor = AppConfig.Colors.imagesBackgoundColor
        button.tintColor = AppConfig.Colors.titlesColor
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImage.image = nil
    }
    
    override func configureView() {
        super.configureView()
        addSubview(mainImage)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(favouriteButton)
        self.favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
    }
    
    override func makeConstraints() {
        super.makeConstraints()

        mainImage.snp.remakeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(12)
            make.top.equalToSuperview().inset(12)
            make.height.equalToSuperview().multipliedBy(0.37)
        }
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(mainImage.snp.bottom).offset(12)
            make.trailing.leading.equalToSuperview().inset(12)
        }
        descriptionLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.trailing.leading.equalToSuperview().inset(12)
        }
        favouriteButton.snp.remakeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            make.trailing.leading.equalToSuperview().inset(12)
            make.height.equalTo(isPad ? 46 : 32)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func configureCell(item: ItemsModel) {
        if let data = item.imageData, let image = UIImage(data: data) {
            self.mainImage.image = image
        }
        self.isFavourite = item.isFavourite
        favouriteButton.tintColor = item.isFavourite ? AppConfig.Colors.buttonsColors : .white
        favouriteButton.setImage(item.isFavourite ? AppConfig.Icons.favoritesFill : AppConfig.Icons.favoritesEmpty)
        self.titleLabel.text = item.title
        self.descriptionLabel.text = item.description
    }
    
    @objc func favouriteButtonTapped() {
        self.isFavourite.toggle()
        togleFavouriteStatus()
    }
    
    func togleFavouriteStatus() {
        self.favouriteComplition?(favouriteButton.tag)
    }
}

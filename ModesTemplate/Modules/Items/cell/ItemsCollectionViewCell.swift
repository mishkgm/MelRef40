//
//  ItemsCollectionViewCell.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 26.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class ItemsCollectionViewCell: BaseCollectionViewCell {
    
    lazy var imageView: UIImageView = {
       var view = UIImageView()
        view.backgroundColor = AppConfig.Colors.imagesBackgoundColor
        return view
    }()
    
    lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont(size: 14, type: .bold)
        label.textColor = AppConfig.Colors.titlesColor
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
       var label = UILabel()
        label.font = UIFont(size: 10, type: .regular)
        label.numberOfLines = 3
        label.textColor = AppConfig.Colors.descriptionsColor
        label.isHidden = true
        return label
    }()
    
    lazy var favouriteButton: UIButton = {
       var button = UIButton()
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    override func configureView() {
        super.configureView()
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        backgroundColor = AppConfig.Colors.cellBackgroundColor
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(favouriteButton)
    }
    
    override func makeConstraints() {
        imageView.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(12)
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        favouriteButton.snp.remakeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.height.width.equalTo(isPad ? 24 : 36)
        }
    }
    
    func configureCell(item: ItemsModel) {
        if let data = item.imageData, let image = UIImage(data: data) {
            self.imageView.image = image
        }
        self.titleLabel.text = item.title
        self.descriptionLabel.text = item.description
        isFavourite = item.isFavourite
        favouriteButton.tintColor = item.isFavourite ? AppConfig.Colors.buttonsColors : .white
        favouriteButton.setImage(item.isFavourite ? AppConfig.Icons.favoritesFill : AppConfig.Icons.favoritesEmpty, for: .normal)
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

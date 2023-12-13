//
//  ModsCollectionViewCell.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 27.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class ModsCollectionViewCell: BaseCollectionViewCell {

    lazy var mainImage: UIImageView = {
       var image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = AppConfig.Colors.imagesBackgoundColor
        return image
    }()
    
    lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont(size: 14, type: .bold)
        label.textColor = AppConfig.Colors.titlesColor
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
       var label = UILabel()
        label.numberOfLines = 2
        label.isHidden = true
        label.font = UIFont(size: 14, type: .regular)
        label.textColor = AppConfig.Colors.descriptionsColor

        return label
    }()
    
    lazy var favouriteButton: UIButton = {
       var button = UIButton()
        button.setImage(AppConfig.Icons.favoritesEmpty, for: .normal)
        button.tintColor = .white
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
            make.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(16)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalTo(mainImage.snp.leading).offset(-5)
        }
        favouriteButton.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(isPad ? 36 : 24)
        }
    }
    
    func configureCell(item: ModsModel, isFavouriteSetup: Bool) {
        if let data = item.imageData, let image = UIImage(data: data) {
            self.mainImage.image = image
        }
        self.isFavourite = item.isFavourite
        favouriteButton.tintColor = item.isFavourite ? AppConfig.Colors.buttonsColors : .white
        favouriteButton.setImage(item.isFavourite ? AppConfig.Icons.favoritesFill : AppConfig.Icons.favoritesEmpty, for: .normal)
        self.titleLabel.text = item.title
        self.descriptionLabel.text = item.description
        // Kostil дизайнеры хотят разные ячейки для экране модов и фейворит
        if isFavouriteSetup {
            favouriteSetup()
        }
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
    
    func favouriteSetup() {
        
        mainImage.backgroundColor = .clear
        titleLabel.textAlignment = .left
        mainImage.snp.remakeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(mainImage.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-16)
        }
        favouriteButton.snp.remakeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(16)
            $0.size.equalTo(CGSize(width: 24, height: 24))
        }
    }
}

//
//  ItemsDescriptionView.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 04.12.2023.
//

import Foundation
import UIKit
import SnapKit

final class ItemsDeteilView: BaseView {
    
    lazy var scrollView: UIScrollView = {
       var scrollView = UIScrollView()
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    lazy var conteinerView: UIView = {
       var view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1.5
        view.layer.borderColor = AppConfig.Colors.cellBorderColor.cgColor
        view.backgroundColor = AppConfig.Colors.cellBackgroundColor
        return view
    }()
    
    lazy var imageView: UIImageView = {
       var view = UIImageView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFit
        view.backgroundColor = AppConfig.Colors.imagesBackgoundColor
        return view
    }()
    
    lazy var modDescriptionView = ModDescriptionView()
    
    lazy var buttonsConteiner: UIStackView = {
       var stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var lockIcon: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = AppConfig.Icons.lockIcon
        image.isHidden = true
        return image
    }()
    
    lazy var downloadButton: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1.5
        button.layer.borderColor = AppConfig.Colors.cellBorderColor.cgColor
        button.setTitle("Download", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = AppConfig.Colors.startEditBackground
        button.setTitleColor(AppConfig.Colors.startEditForeground, for: .normal)
        button.titleLabel?.font = UIFont(size: 24, type: .bold)
        return button
    }()
    
    lazy var exportButton: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1.5
        button.layer.borderColor = AppConfig.Colors.cellBorderColor.cgColor
        button.setTitle("Export", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = AppConfig.Colors.startEditBackground
        button.setTitleColor(AppConfig.Colors.startEditForeground, for: .normal)
        button.titleLabel?.font = UIFont(size: 24, type: .bold)
        return button
    }()
    
    lazy var favouriteButton: CustomButton = {
        var button = CustomButton()
        button.layer.cornerRadius = 12
        button.setImage(AppConfig.Icons.favoritesEmpty, size: 40)
        button.setTitle("Favorite", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = AppConfig.Colors.imagesBackgoundColor
        button.setTitleColor(AppConfig.Colors.titlesColor, for: .normal)
        button.titleLabel?.font = UIFont(size: 14, type: .regular)
        return button
    }()

    override func configureView() {
        super.configureView()
        addSubview(scrollView)
        scrollView.addSubview(conteinerView)
        conteinerView.addSubview(imageView)
        conteinerView.addSubview(modDescriptionView)
        conteinerView.addSubview(favouriteButton)
        addSubview(buttonsConteiner)
        buttonsConteiner.addArrangedSubview(downloadButton)
        buttonsConteiner.addArrangedSubview(exportButton)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(5)
            make.trailing.leading.equalToSuperview().inset(isPad ? 60 : 20)
            make.bottom.equalToSuperview()
        }
        conteinerView.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(snp.width).offset(isPad ? -120 : -40)
            make.bottom.equalToSuperview().offset(isPad ? -240 : -100)
        }
        imageView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.leading.equalToSuperview().inset(12)
            make.height.equalTo(screenSize.height / 5)
        }
        modDescriptionView.snp.remakeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        favouriteButton.snp.remakeConstraints { make in
            make.height.equalTo(buttonsConteiner.snp.height)
            make.top.equalTo(modDescriptionView.snp.bottom).offset(12)
            make.trailing.leading.bottom.equalToSuperview().inset(12)
        }
        buttonsConteiner.snp.remakeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(isPad ? 60 : 20)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(isPad ? 115 : 56)
        }
    }
    
    func configureView(_ model: DeteilModel) {
        imageView.image = model.image
        modDescriptionView.configureTitles(with: model)
        self.favouriteButton.setImage(model.isFavourite ? AppConfig.Icons.favoritesFill : AppConfig.Icons.favoritesEmpty, size: 40)
    }
    
    func configureButtons(for isDonwloaded: Bool) {
        downloadButton.isHidden = isDonwloaded
        exportButton.isHidden = !isDonwloaded
        buttonsConteiner.layoutIfNeeded()
    }
}

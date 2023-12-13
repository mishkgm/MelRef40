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
       var view = UIScrollView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var conteinerView: UIView = {
       var view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var imageView: UIImageView = {
       var view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = AppConfig.Colors.imagesBackgoundColor
        return view
    }()
    
    lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.textColor = .white
        label.font = UIFont(size: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
       var label = UILabel()
        label.textColor = UIColor(hex: "#BCC5C9")
        label.font = UIFont(size: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var buttonsConteiner: UIStackView = {
       var stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillProportionally
        stack.layoutMargins = UIEdgeInsets(top: 12, left: 20, bottom: 30, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.backgroundColor = #colorLiteral(red: 0.1403699815, green: 0.1455616951, blue: 0.1575081646, alpha: 1)
        return stack
    }()
    
    lazy var favouriteButton: UIButton = {
        var button = UIButton()
        button.setImage(AppConfig.Icons.favoritesEmpty, for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(AppConfig.Colors.titlesColor, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    lazy var downloadButton: UIButton = {
        var button = UIButton()
        button.setTitle(localizedString(forKey: "download"), for: .normal)
        button.backgroundColor = AppConfig.Colors.startEditBackground
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(size: 18, type: .regular)
        button.titleLabel?.textAlignment = .center

        return button
    }()
    
    lazy var shareButton: UIButton = {
        var button = UIButton()
        button.setTitle(localizedString(forKey: "export"), for: .normal)
        button.backgroundColor = AppConfig.Colors.startEditBackground
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(size: 18, type: .regular)
        button.titleLabel?.textAlignment = .center
        button.isHidden = true
        return button
    }()

    override func configureView() {
        super.configureView()
        addSubview(scrollView)
        scrollView.addSubview(conteinerView)
        conteinerView.addSubview(imageView)
        conteinerView.addSubview(titleLabel)
        conteinerView.addSubview(descriptionLabel)
        addSubview(buttonsConteiner)
        buttonsConteiner.addArrangedSubview(downloadButton)
        buttonsConteiner.addArrangedSubview(shareButton)
        buttonsConteiner.addArrangedSubview(favouriteButton)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom)
            make.trailing.leading.equalToSuperview().inset(isPad ? 40 : 0)
            make.bottom.equalTo(buttonsConteiner.snp.top)
        }
        conteinerView.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(snp.width).offset(isPad ? -80 : 0)
            make.centerX.equalToSuperview()
        }
        imageView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.leading.equalToSuperview().inset(20)
            make.height.equalTo(screenSize.height / 2.4)
        }
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        descriptionLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-10)
        }
        buttonsConteiner.snp.remakeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(0)
            make.height.equalTo(screenSize.height / 7)
            make.bottom.equalToSuperview()
        }
        favouriteButton.snp.remakeConstraints { make in
            make.width.height.equalTo(isPad ? 100 : 44)
        }
    }
    
    func configureView(_ model: DeteilModel) {
        imageView.image = model.image
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        self.configForFavourite(isFavourite: model.isFavourite)
    }
    
    func configureButtons(for isDonwloaded: Bool) {
        self.downloadButton.isHidden = isDonwloaded
        self.shareButton.isHidden = !isDonwloaded
        self.buttonsConteiner.layoutSubviews()
    }
    
    private func configForFavourite(isFavourite: Bool) {
        switch isFavourite {
        case true:
            favouriteButton.setImage(AppConfig.Icons.favoritesFill, for: .normal)
            favouriteButton.tintColor = AppConfig.Colors.startEditBackground
        case false:
            favouriteButton.setImage(AppConfig.Icons.favoritesEmpty, for: .normal)
            favouriteButton.tintColor = .black
        }
    }
}

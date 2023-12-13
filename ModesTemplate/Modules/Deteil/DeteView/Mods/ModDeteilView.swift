//
//  DeteilView.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 28.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class DeteilView: BaseView {
    
    lazy var scrollView: UIScrollView = {
       var scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    lazy var conteinerView: UIView = {
       var view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var imageView: UIImageView = {
       var view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.contentMode = .scaleToFill
        view.backgroundColor = AppConfig.Colors.imagesBackgoundColor
        view.layer.borderWidth = 1
        view.layer.borderColor = AppConfig.Colors.cellBorderColor.cgColor
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
    
    lazy var startEditButton: DetailButton = {
        var button = DetailButton()
        button.setButtonIcon(image: AppConfig.Icons.startEditIcon)
        button.setLocalizedTitle(key: "start-edit-mod")
        button.setBackgroundColor(color: AppConfig.Colors.startEditBackground)
        button.setForegroundColor(color: AppConfig.Colors.startEditForeground)
        button.setTitleFont(font: UIFont(size: 16, type: .regular))
        return button
    }()
    
    lazy var downloadButton: DetailButton = {
        var button = DetailButton()
        button.setButtonIcon(image: AppConfig.Icons.saveicon)
        button.setLocalizedTitle(key: "download")
        button.setBackgroundColor(color: AppConfig.Colors.deteilModsbuttonBackground)
        button.setForegroundColor(color: AppConfig.Colors.titlesColor)
        button.setTitleFont(font: UIFont(size: 16, type: .regular))
        button.layer.borderWidth = 1
        button.layer.borderColor = AppConfig.Colors.cellBorderColor.cgColor
        return button
    }()
    
    lazy var shareButton: DetailButton = {
        var button = DetailButton()
        button.setButtonIcon(image: AppConfig.Icons.shareIcon)
        button.setLocalizedTitle(key: "share")
        button.setBackgroundColor(color: AppConfig.Colors.deteilModsbuttonBackground)
        button.setForegroundColor(color: AppConfig.Colors.titlesColor)
        button.setTitleFont(font: UIFont(size: 16, type: .regular))
        button.layer.borderWidth = 1
        button.layer.borderColor = AppConfig.Colors.cellBorderColor.cgColor
        return button
    }()
    
    override func configureView() {
        super.configureView()
        addSubview(scrollView)
        scrollView.addSubview(conteinerView)
        conteinerView.addSubview(imageView)
        conteinerView.addSubview(modDescriptionView)
        conteinerView.addSubview(buttonsConteiner)
        buttonsConteiner.addArrangedSubview(startEditButton)
        buttonsConteiner.addArrangedSubview(downloadButton)
        buttonsConteiner.addArrangedSubview(shareButton)
        addSubview(lockIcon)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(5)
            make.trailing.leading.equalToSuperview().inset(isPad ? 40 : 0)
            make.bottom.equalToSuperview()
        }
        conteinerView.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(snp.width).offset(isPad ? -80 : 0 )
//            make.bottom.equalTo(buttonsConteiner.snp.bottom)
            make.bottom.equalToSuperview()
        }
        imageView.snp.remakeConstraints { make in
//            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.top.equalToSuperview().offset(10)
            make.trailing.leading.equalToSuperview().inset(20)
            make.height.equalTo(screenSize.height / 7.2)
        }
        modDescriptionView.snp.remakeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        buttonsConteiner.snp.remakeConstraints { make in
            make.top.equalTo(modDescriptionView.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        startEditButton.snp.remakeConstraints { make in
            make.height.equalTo(isPad ? 100 : 50)
        }
        lockIcon.snp.remakeConstraints { make in
            make.trailing.equalTo(startEditButton.snp.trailing).inset(20)
            make.centerY.equalTo(startEditButton.snp.centerY)
            make.height.equalTo(startEditButton.snp.height).multipliedBy(0.6)
            make.width.equalTo(lockIcon.snp.height)
        }
    }
    
    func lockView(_ hidden: Bool) {
        startEditButton.alpha = hidden ? 1 : 0.5
        lockIcon.isHidden = hidden
    }
    
    func configureView(_ model: DeteilModel) {
        imageView.image = model.image
        modDescriptionView.configureTitles(with: model)
    }
    
    func configureButtons(for isDonwloaded: Bool) {
        downloadButton.setLocalizedTitle(key: isDonwloaded ? "downloaded" : "download")
        downloadButton.isEnabled = !isDonwloaded
        shareButton.isEnabled = isDonwloaded
        shareButton.alpha = isDonwloaded ? 1.0 : 0.5
        downloadButton.alpha = isDonwloaded ? 0.5 : 1.0
    }
}

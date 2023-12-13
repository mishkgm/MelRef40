//
//  CustomAlertView.swift
//  ModesTemplate
//
//  Created by evhn on 29.11.2023.
//

import UIKit
import SnapKit

final class CustomAlertView: BaseView {

    private lazy var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = AppConfig.Colors.deleteBackground
        return view
    }()
    
    private lazy var deleteTitle: UILabel = {
        var label = UILabel()
        label.textColor = AppConfig.Colors.titlesColor
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont(size: 24, type: .regular)
        return label
    }()
    
    private lazy var deleteDescription: UILabel = {
        var label = UILabel()
        label.textColor = AppConfig.Colors.titlesColor
        label.textAlignment = .center
        label.font = UIFont(size: 14, type: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        var button = UIButton()
        button.setTitle(localizedString(forKey: "delete-action"), for: .normal)
        button.setTitleColor(AppConfig.Colors.titlesColor, for: .normal)
        button.backgroundColor = AppConfig.Colors.destructiveColor
        button.titleLabel?.font = UIFont(size: 14, type: .semiBold)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        var button = UIButton()
        button.setTitle(localizedString(forKey: "cancel-action"), for: .normal)
        button.setTitleColor(AppConfig.Colors.titlesColor, for: .normal)
        button.backgroundColor = AppConfig.Colors.cancelColor
        button.titleLabel?.font = UIFont(size: 14, type: .semiBold)
        return button
    }()
    
    lazy var blurEffect: UIVisualEffectView = {
       var blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blur.alpha = 0.8
        return blur
    }()
    
    override func configureView() {
        addSubview(blurEffect)
        addSubview(containerView)
        containerView.addSubview(deleteTitle)
        containerView.addSubview(deleteDescription)
    }
    
    override func makeConstraints() {
        blurEffect.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        containerView.snp.remakeConstraints {
            $0.centerY.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: screenSize.width - 40, height: screenSize.height / 5))
        }
        deleteTitle.snp.remakeConstraints {
            $0.top.equalTo(containerView).offset(20)
            $0.leading.trailing.equalTo(containerView).inset(20)
        }
        deleteDescription.snp.remakeConstraints {
            $0.top.equalTo(deleteTitle.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(containerView).inset(20)
        }
        
        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(deleteButton)
        buttonStack.spacing = 38
        addSubview(buttonStack)
        buttonStack.snp.remakeConstraints {
            $0.top.equalTo(deleteDescription.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(containerView).inset(20)
            $0.bottom.equalTo(containerView.snp.bottom).offset(-20)
            $0.height.equalTo(40)
        }
    }
    
    public func setupAlert(type: CustomAlertConfig) {
        deleteTitle.text = type.title
        deleteDescription.text = type.description
    }
}

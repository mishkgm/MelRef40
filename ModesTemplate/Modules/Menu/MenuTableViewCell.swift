//
//  MenuTableViewCell.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 26.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class MenuTableViewCell: BaseTableViewCell {
    
    lazy var conteinerView: UIView = {
       var view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor(hex: "#FAFEFB").cgColor
        return view
    }()
    
    lazy var selectedBackground: UIImageView = {
       var image = UIImageView()
        image.image = AppConfig.Icons.menuGradient
        return image
    }()
    
    lazy var lockImage: UIImageView = {
       var image = UIImageView()
        image.image = AppConfig.Icons.lockIcon
        image.contentMode = .scaleAspectFit
        image.isHidden = true
        return image
    }()
    
    lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.font = UIFont(size: 24, type: .regular)
        label.textColor = AppConfig.Colors.titlesColor
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.conteinerView.setGradientBorder(width: 1, colors: [AppConfig.Colors.cellBorderColor, UIColor(hex: "#42535A")])
    }
    
    override func configureView() {
        backgroundColor = .clear
        addSubview(conteinerView)
        conteinerView.addSubview(lockImage)
        conteinerView.addSubview(selectedBackground)
        conteinerView.addSubview(titleLabel)
    }
    
    override func makeConstraints() {
        lockImage.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
            make.width.equalTo(lockImage.snp.height)
        }
        conteinerView.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        selectedBackground.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.remakeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configureCell(for type: ControllersType, isSelected: Bool) {
        self.titleLabel.text = type.title.uppercased()
        configure(for: isSelected)
        if type == .editor && !IAPManager_MWP.shared.productBought.contains(.unlockFuncProduct) {
            self.lockSetup()
        } else if type == .skins && !IAPManager_MWP.shared.productBought.contains(.unlockOther) {
            self.lockSetup()
        }
    }
    
    private func configure(for isSelected: Bool) {
        self.selectedBackground.isHidden = !isSelected
        self.conteinerView.backgroundColor = AppConfig.Colors.isUnselectedCategory//.gray.withAlphaComponent(0.9)
    }
    
    private func lockSetup() {
        self.conteinerView.backgroundColor = UIColor(hex: "#242528")
        self.lockImage.isHidden = false
        self.titleLabel.textColor = UIColor(hex: "#989898")
    }
}

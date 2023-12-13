//
//  SettingViewCell.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 27.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class SettingViewCell: BaseTableViewCell {
    
    lazy var conteinerView: UIView = {
       var view = UIView()
        view.backgroundColor = AppConfig.Colors.cellBackgroundColor
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1.5
        view.layer.borderColor = AppConfig.Colors.cellBorderColor.cgColor
        return view
    }()
    
    lazy var iconImage: UIImageView = {
       var image = UIImageView()
        return image
    }()
    
    lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.textColor = AppConfig.Colors.titlesColor
        label.font = UIFont(size: 16, type: .semiBold)
        return label
    }()
    
    lazy var dropListImage: UIImageView = {
       var image = UIImageView()
        image.image = AppConfig.Icons.dropArrowRight
        image.contentMode = .scaleAspectFit
        return image
    }()
 
    override func configureView() {
        backgroundColor = .clear
        addSubview(conteinerView)
        conteinerView.addSubview(iconImage)
        conteinerView.addSubview(titleLabel)
        conteinerView.addSubview(dropListImage)
    }
    
    override func makeConstraints() {
        conteinerView.snp.remakeConstraints { make in
            make.bottom.top.equalToSuperview().inset(6)
            make.trailing.leading.equalToSuperview()
        }
        iconImage.snp.remakeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(16)
            make.width.equalTo(iconImage.snp.height)
        }
        titleLabel.snp.remakeConstraints { make in
            make.leading.equalTo(iconImage.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
        dropListImage.snp.remakeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(dropListImage.snp.height)
        }
    }
    
    func configureCell(setting: Setting) {
        self.titleLabel.text = setting.rawValue
        self.iconImage.image = setting.icon
    }
}

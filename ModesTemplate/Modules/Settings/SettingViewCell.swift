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
    
    lazy var bottomSeparator: UIView = {
       var view = UIView()
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bottomSeparator.addGradient(colors: [AppConfig.Colors.cellBorderColor, UIColor(hex: "#42535A")])
    }
 
    override func configureView() {
        backgroundColor = .clear
        addSubview(iconImage)
        addSubview(titleLabel)
        addSubview(dropListImage)
        addSubview(bottomSeparator)
    }
    
    override func makeConstraints() {
        iconImage.snp.remakeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(20)
            make.width.equalTo(iconImage.snp.height)
        }
        titleLabel.snp.remakeConstraints { make in
            make.leading.equalTo(iconImage.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        dropListImage.snp.remakeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        bottomSeparator.snp.remakeConstraints { make in
            make.height.equalTo(1.5)
            make.trailing.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureCell(setting: Setting) {
        self.titleLabel.text = setting.rawValue
        self.iconImage.image = setting.icon
    }
}

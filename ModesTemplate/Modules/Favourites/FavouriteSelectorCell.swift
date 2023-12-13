//
//  FavouriteSelectorCell.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 29.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class FavouriteSelectorCell: BaseCollectionViewCell {
    
    lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont(size: 16, type: .regular)
        return label
    }()
    
    lazy var selecteCheckMark: UIImageView = {
       var image = UIImageView()
        image.image = AppConfig.Icons.checkmark
        image.isHidden = true
        return image
    }()
    
    override func configureView() {
        addSubview(titleLabel)
        addSubview(selecteCheckMark)
        backgroundColor = .clear
    }
    
    override func makeConstraints() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.trailing.leading.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
        }
        selecteCheckMark.snp.remakeConstraints { make in
            make.centerY.equalToSuperview().offset(-8)
            make.trailing.equalToSuperview().inset(0)
            make.height.width.equalTo(isPad ? 36 : 24)
        }
    }
}

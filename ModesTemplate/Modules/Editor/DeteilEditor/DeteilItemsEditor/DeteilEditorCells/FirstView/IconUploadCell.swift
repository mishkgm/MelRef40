//
//  IconUploadCell.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 04.12.2023.
//

import Foundation
import UIKit
import SnapKit

final class IconUploadCell<model: EditorCellModel>: EditorCell {
    
    lazy var iconImage: UIImageView = {
       var image = UIImageView()
        image.layer.cornerRadius = 12
        image.contentMode = .scaleAspectFit
        image.backgroundColor = AppConfig.Colors.imagesBackgoundColor
        return image
    }()
    
    lazy var iconButton: UIButton = {
       var button = UIButton()
        button.layer.cornerRadius = 12
        button.setTitle("Upload Icon", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9196677804, green: 0.9337717891, blue: 0.9251947999, alpha: 1)
        button.setTitleColor(UIColor(hex: "#161717"), for: .normal)
        button.titleLabel?.font = UIFont(size: 16)
        return button
    }()

    lazy var iconConteiner: UIStackView = {
        var stack = UIStackView()
        stack.layer.cornerRadius = 12
        stack.layer.borderWidth = 1.5
        stack.layer.borderColor = AppConfig.Colors.cellBorderColor.cgColor
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.backgroundColor = AppConfig.Colors.cellBackgroundColor
        stack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.spacing = 10
        return stack
    }()
    
    override func configureView() {
        super.configureView()
        contentView.addSubview(iconConteiner)
        iconConteiner.addArrangedSubview(iconImage)
        iconConteiner.addArrangedSubview(iconButton)
        self.iconButton.addTarget(self, action: #selector(loadIcon), for: .touchUpInside)
    }
    
    override func makeConstraints() {
        iconConteiner.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        iconImage.snp.remakeConstraints { make in
//            make.height.equalToSuperview().multipliedBy(0.6)
            make.trailing.leading.top.equalToSuperview().inset(12)
        }
        iconButton.snp.remakeConstraints { make in
            make.height.equalTo(isPad ? 80 : 40)
            make.top.equalTo(iconImage.snp.bottom).offset(12)
            make.trailing.leading.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    override func configure(object: RealmEditorDeteilModel) {
        self.iconImage.image = UIImage(data: object.iconData)
    }
    
    @objc func loadIcon() {
        self.openImagePicker?()
    }
}

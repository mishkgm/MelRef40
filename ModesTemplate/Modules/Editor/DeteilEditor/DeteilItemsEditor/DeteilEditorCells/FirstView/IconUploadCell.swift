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
    
    lazy var iconTitle: UILabel = {
       var label = UILabel()
        label.textColor = .white
        label.text = "Load icon:"
        label.font = UIFont(size: 16)
        return label
    }()
    
    lazy var iconButton: UIButton = {
       var button = UIButton()
        button.setTitle("Upload", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9390731454, green: 0.8152710795, blue: 0.2688673437, alpha: 1)
        button.setTitleColor(UIColor(hex: "#3D3F44"), for: .normal)
        button.titleLabel?.font = UIFont(size: 16)
        return button
    }()
    
    lazy var iconImage: UIImageView = {
       var image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = UIColor(hex: "#737B89")
        return image
    }()
    
    lazy var iconButtonConteiner: UIStackView = {
       var stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.backgroundColor = .clear
        return stack
    }()
    
    lazy var iconConteiner: UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.backgroundColor = AppConfig.Colors.deteilModsbuttonBackground
        stack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.spacing = 10
        return stack
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.iconConteiner.setGradientBorder(width: 1, colors: [AppConfig.Colors.cellBorderColor, UIColor(hex: "#42535A")])
        }
    }
    
    override func configureView() {
        super.configureView()
        contentView.addSubview(iconConteiner)
        iconConteiner.addArrangedSubview(iconButtonConteiner)
        iconButtonConteiner.addArrangedSubview(iconTitle)
        iconButtonConteiner.addArrangedSubview(iconButton)
        iconConteiner.addArrangedSubview(iconImage)
        self.iconButton.addTarget(self, action: #selector(loadIcon), for: .touchUpInside)
    }
    
    override func makeConstraints() {
        iconConteiner.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        iconImage.snp.remakeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.6)
        }
    }
    
    override func configure(object: RealmEditorDeteilModel) {
        self.iconImage.image = UIImage(data: object.iconData)
    }
    
    @objc func loadIcon() {
        self.openImagePicker?()
    }
}

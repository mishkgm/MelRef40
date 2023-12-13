//
//  ModsCategoriesViewCell.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 27.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class CategoriesViewCell: BaseCollectionViewCell {
    
    private lazy var containerBackView: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(size: 18, type: .regular)
        label.textColor = .white
        return label
    }()
    
    lazy var selectView: UIView = {
       var view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var lockIcon: UIImageView = {
       var image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = AppConfig.Icons.lockIcon
        return image
    }()
    
    override func configureView() {
        addSubview(containerBackView)
        addSubview(titleLabel)
        addSubview(selectView)
        addSubview(lockIcon)
    }
    
    override func makeConstraints() {
        containerBackView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.remakeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(16)
        }
        selectView.snp.remakeConstraints { make in
            make.bottom.trailing.leading.equalToSuperview()
            make.height.equalTo(1.5)
        }
        lockIcon.snp.remakeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(5)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    func configureCell(item: String?, isLoked: Bool, isSelected: Bool) {
        guard let item = item else { return }
        self.selectView.isHidden = !isSelected
        self.titleLabel.text = item
        self.lockIcon.isHidden = !isLoked
        self.titleLabel.textColor = isLoked ? UIColor(hex: "#989898") : .white
    }
}
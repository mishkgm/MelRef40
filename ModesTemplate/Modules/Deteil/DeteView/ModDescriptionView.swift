//
//  ModDescriptionView.swift
//  ModesTemplate
//
//  Created by evhn on 29.11.2023.
//

import UIKit
import SnapKit

final class ModDescriptionView: BaseView {

    private lazy var modTile: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.textColor = AppConfig.Colors.mainTextColor
        label.font = UIFont(size: 20, type: .medium)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var modDescription: UILabel = {
        var label = UILabel()
        label.textColor = AppConfig.Colors.mainTextColor
        label.font = UIFont(size: 16, type: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    override func configureView() {
        addSubview(modTile)
        addSubview(modDescription)
    }
    
    override func makeConstraints() {
        modTile.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.leading.equalToSuperview()
        }
        modDescription.snp.remakeConstraints { make in
            make.top.equalTo(modTile.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    public func configureTitles(with model: DeteilModel) {
        modDescription.text = model.description
        modTile.text = model.title
    }
}

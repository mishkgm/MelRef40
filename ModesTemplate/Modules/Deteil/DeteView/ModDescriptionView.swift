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
        label.numberOfLines = 2
        label.textColor = AppConfig.Colors.mainTextColor
        label.font = UIFont(size: 20, type: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var modDescription: UILabel = {
        var label = UILabel()
        label.textColor = AppConfig.Colors.mainTextColor
        label.font = UIFont(size: 14, type: .semiBold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override func configureView() {
        backgroundColor = AppConfig.Colors.deteilModsbuttonBackground
        addSubview(modTile)
        addSubview(modDescription)
        layer.borderWidth = 1.5
        layer.borderColor = AppConfig.Colors.cellBorderColor.cgColor
    }
    
    override func makeConstraints() {
        modTile.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        modDescription.snp.remakeConstraints { make in
            make.top.equalTo(modTile.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-10)
        }
    }

    public func configureTitles(with model: DeteilModel) {
        modDescription.text = model.description
        modTile.text = model.title
    }
}

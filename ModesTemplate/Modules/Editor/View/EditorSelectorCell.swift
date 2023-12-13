//
//  EditorSelectorCell.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 30.11.2023.
//

import Foundation
import UIKit
import SnapKit

fileprivate enum EditorSelectorCellStyle: RawRepresentable {
    typealias RawValue = Bool
    case selected
    case deselected
    
    var color: UIColor {
        switch self {
        case .selected:
            return UIColor(hex: "#F0D045")
        case .deselected:
            return UIColor(hex: "#242528")
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .selected:
            return UIColor(hex: "#242528")
        case .deselected:
            return UIColor(hex: "#BCC5C9")
        }
    }
    
    var rawValue: RawValue {
        return self == .selected ? true : false
    }
    
    init?(rawValue: RawValue) {
        self = rawValue == true ? .selected : .deselected
    }
}

final class EditorSelectorCell: BaseCollectionViewCell {
    
    lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.font = UIFont(size: 16)
        label.textAlignment = .center
        return label
    }()
    
    lazy var imageView: UIImageView = {
       var image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override func configureView() {
        addSubview(imageView)
        addSubview(titleLabel)
    }
    
    override func makeConstraints() {
        imageView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalTo(imageView.snp.height)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)
        }
    }
    
    func configureCell(type: EditorContentType, isSelected: Bool) {
        let selectedType = EditorSelectorCellStyle(rawValue: isSelected)
        titleLabel.textColor = selectedType?.textColor
        imageView.tintColor = selectedType?.textColor
        self.backgroundColor = selectedType?.color
        self.titleLabel.text = type.rawValue
        self.imageView.image = type.image
    }
}

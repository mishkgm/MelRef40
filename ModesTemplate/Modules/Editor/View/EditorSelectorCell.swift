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
            return .clear
        case .deselected:
            return .clear
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .selected:
            return .white
        case .deselected:
            return UIColor(hex: "#EBEEEC")
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
    
    lazy var selectedView: UIView = {
       var view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override func configureView() {
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(selectedView)
    }
    
    override func makeConstraints() {
        titleLabel.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        selectedView.snp.remakeConstraints { make in
            make.height.equalTo(1.5)
            make.trailing.leading.bottom.equalToSuperview()
        }
    }
    
    func configureCell(type: EditorContentType, isSelected: Bool) {
        let selectedType = EditorSelectorCellStyle(rawValue: isSelected)
        titleLabel.textColor = selectedType?.textColor
        self.titleLabel.text = type.rawValue
        self.selectedView.isHidden = !isSelected
    }
}

//
//  TitleCell.swift
//  ModesTemplate
//
//
//

import Foundation
import UIKit
import SnapKit

final class TitleCell: EditorCell {
    
    lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.text = "Set file settings:"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(size: 16, type: .medium)!
        return label
    }()
    
    override func configureView() {
        super.configureView()
        addSubview(titleLabel)
    }
    
    override func makeConstraints() {
        titleLabel.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.trailing.leading.equalToSuperview()
        }
    }
}

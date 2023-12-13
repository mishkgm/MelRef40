//
//  DeteilEditorCells.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 04.12.2023.
//

import Foundation
import UIKit
import SnapKit

final class NameTextFieldCell<model: EditorCellModel>: EditorCell {
    
    lazy var conteinerView: UIView = {
       var view = UIView()
        view.backgroundColor = AppConfig.Colors.deteilModsbuttonBackground
        return view
    }()
    
    lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.textColor = .white
        label.font = UIFont(size: 16)
        label.textAlignment = .left
        label.text = "Name"
        return label
    }()
    
    lazy var textField: DeteilEditorTextField = {
        var field = DeteilEditorTextField(fieldType: .name)
        field.delegate = self
        field.textColor = .white
        field.backgroundColor = .clear
        field.textAlignment = .right
        return field
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.conteinerView.setGradientBorder(width: 1, colors: [AppConfig.Colors.cellBorderColor, UIColor(hex: "#42535A")])
        }
    }
    
    override func configureView() {
        super.configureView()
        contentView.addSubview(conteinerView)
        conteinerView.addSubview(titleLabel)
        conteinerView.addSubview(textField)
    }
    
    override func makeConstraints() {
        conteinerView.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        titleLabel.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        textField.snp.remakeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configure(object: RealmEditorDeteilModel) {
        self.textField.text = object.name
    }
}

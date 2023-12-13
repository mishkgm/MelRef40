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
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.backgroundColor = AppConfig.Colors.editorNameTextFieldBackground
        
        return view
    }()
    
    lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.textColor = .white
        label.font = UIFont(size: 18, type: .medium)
        label.textAlignment = .left
        label.isHidden = true
        label.text = "Name"
        return label
    }()
    
    lazy var textField: NameField = {
        var field = NameField(fieldType: .name)
        field.delegate = self
        field.textColor = .white
        field.backgroundColor = .clear
        field.textAlignment = .left
        let text = NSMutableAttributedString(string: "Name", attributes: [.foregroundColor: UIColor(hex: "#DEDEDE")])
        field.attributedPlaceholder = text
        return field
    }()
    
    override func configureView() {
        super.configureView()
        contentView.addSubview(conteinerView)
        conteinerView.addSubview(titleLabel)
        conteinerView.addSubview(textField)
    }
    
    override func makeConstraints() {
        conteinerView.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(2)
            make.trailing.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(12)
        }
        titleLabel.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        textField.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configure(object: RealmEditorDeteilModel) {
        self.textField.text = object.name
    }
}

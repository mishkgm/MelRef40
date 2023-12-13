//
//  CoordinateFieldCell.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 04.12.2023.
//

import Foundation
import UIKit
import SnapKit

final class CoordinateFieldCellX<model: EditorCellModel>: EditorCell {
    
    lazy var conteinerStack: UIStackView = {
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0
        stack.backgroundColor = .clear
        stack.distribution = .fillProportionally
       return stack
    }()
    
    lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.text = "Living"
        label.font = UIFont(size: 16)
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = #colorLiteral(red: 0.9390731454, green: 0.8152710795, blue: 0.2688673437, alpha: 1)
        return label
    }()
    
    private var textFields: [DeteilEditorTextField] = []
    
    override func configureView() {
        super.configureView()
        contentView.addSubview(conteinerStack)
        conteinerStack.addArrangedSubview(titleLabel)
        model.types(for: .coordinatesX).forEach { type in
            let stack = createStack()
            let label = createLabel(text: type.displayName)
            let textField = DeteilEditorTextField(fieldType: type)
            textField.delegate = self
            textField.backgroundColor = UIColor(hex: "#BCC5C9")
            textField.layer.borderWidth = 1.5
            textField.layer.borderColor = UIColor(hex: "#F0D045").cgColor
            textField.textColor = .black
            textField.textAlignment = .center
            stack.addArrangedSubview(label)
            stack.addArrangedSubview(textField)
            self.conteinerStack.addArrangedSubview(stack)
            textField.snp.remakeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.7)
            }
            stack.snp.remakeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.32)
            }
            self.textFields.append(textField)
        }
    }
    
    override func makeConstraints() {
        conteinerStack.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        titleLabel.snp.remakeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.35)
        }
    }
    
    override func configure(object: RealmEditorDeteilModel) {
        textFields.forEach { field in
            switch field.fieldType {
            case .xValue:
                field.text = object.xValue
            case .yValue:
                field.text = object.yValue
            case .widthValue:
                field.text = object.widthValue
            case .heightValue:
                field.text = object.heightValue
            default: break
            }
        }
    }
    
    func createStack() -> UIStackView {
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.backgroundColor = .clear
        stack.distribution = .fillProportionally
       return stack
    }
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(size: 16)
        return label
    }
}

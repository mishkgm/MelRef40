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
    
    lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.text = "Set file settings:"
        label.font = UIFont(size: 18, type: .medium)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var conteinerView: UIView = {
       var view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 0.5
        view.layer.borderColor = AppConfig.Colors.cellBorderColor.cgColor
        view.backgroundColor = #colorLiteral(red: 0.2714084983, green: 0.4273136854, blue: 0.3375319242, alpha: 1)
        return view
    }()
    
    lazy var conteinerStack: UIStackView = {
        var stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.axis = .vertical
        stack.backgroundColor = .clear
       return stack
    }()
    
    private var textFields: [DeteilEditorTextField] = []
    
    override func configureView() {
        super.configureView()
        contentView.addSubview(conteinerView)
        conteinerView.addSubview(titleLabel)
        conteinerView.addSubview(conteinerStack)
        
        let labelStack = createStack()
        ["Living", "Metal"].forEach { text in
            let label = createLabel(text: text)
            labelStack.addArrangedSubview(label)
        }
        
        self.conteinerStack.addArrangedSubview(labelStack)
        self.configureStack(types: model.types(for: .coordinatesW))
        self.configureStack(types: model.types(for: .coordinatesX))
    }
    
    override func makeConstraints() {
        conteinerView.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.trailing.leading.equalToSuperview().inset(12)
        }
        conteinerStack.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview().inset(12)
            make.trailing.leading.equalToSuperview().inset(12)
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
    
    func configureStack(types: [EditorDataType]) {
        let firstStack = createStack()
        types.forEach { type in
            let stack = createStack()
            let label = createLabel(text: type.displayName)
            let textField = DeteilEditorTextField(fieldType: type)
            textField.delegate = self
            textField.backgroundColor = UIColor(hex: "#FAFEFB").withAlphaComponent(0.5)
            textField.layer.cornerRadius = 5
            textField.textColor = .white
            textField.textAlignment = .center
            stack.addArrangedSubview(label)
            stack.addArrangedSubview(textField)
            firstStack.addArrangedSubview(stack)
            self.textFields.append(textField)
        }
        
        self.conteinerStack.addArrangedSubview(firstStack)
        (firstStack.arrangedSubviews[0] as? UIStackView)?.arrangedSubviews[0].snp.remakeConstraints({ make in
            make.width.equalToSuperview().multipliedBy(0.35)
        })
        (firstStack.arrangedSubviews[0] as? UIStackView)?.arrangedSubviews[1].snp.remakeConstraints({ make in
            make.width.equalToSuperview().multipliedBy(0.7)
        })
        (firstStack.arrangedSubviews[1] as? UIStackView)?.arrangedSubviews[0].snp.remakeConstraints({ make in
            make.width.equalToSuperview().multipliedBy(0.35)
        })
        (firstStack.arrangedSubviews[1] as? UIStackView)?.arrangedSubviews[1].snp.remakeConstraints({ make in
            make.width.equalToSuperview().multipliedBy(0.7)
        })
        conteinerStack.layoutSubviews()
    }
    
    func createStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0
        stack.backgroundColor = .clear
        stack.distribution = .fillProportionally
       return stack
    }
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(size: 18)
        return label
    }
}

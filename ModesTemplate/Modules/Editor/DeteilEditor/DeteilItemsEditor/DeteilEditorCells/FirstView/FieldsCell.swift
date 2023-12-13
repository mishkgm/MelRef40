//
//  FieldsCell.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 04.12.2023.
//

import Foundation
import UIKit
import SnapKit

final class FieldCell<model: EditorCellModel>: EditorCell {
    
    lazy var textFieldConteiner: UIStackView = {
       var stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    private var textFields: [DeteilEditorTextField] = []
    
    override func configureView() {
        super.configureView()
        contentView.addSubview(textFieldConteiner)
    }
    
    override func makeConstraints() {
        textFieldConteiner.snp.remakeConstraints { make in
//            make.edges.equalToSuperview().inset()
            make.top.bottom.equalToSuperview().inset(12)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        model.types(for: .fields).forEach { item in
            let stack = createStack()
            let textField = DeteilEditorTextField(fieldType: item)
            let label = createLabel(text: item.displayName)
            
            textField.backgroundColor = #colorLiteral(red: 0.6819491982, green: 0.685982883, blue: 0.6614944339, alpha: 1)
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.white.cgColor
            textField.layer.cornerRadius = 12
            textField.textColor = .white
            textField.textAlignment = .left
            let text = NSMutableAttributedString(string: "Enter text....", attributes: [.foregroundColor: UIColor(hex: "#DEDEDE")])
            textField.attributedPlaceholder = text
            textField.delegate = self
            stack.addArrangedSubview(label)
            stack.addArrangedSubview(textField)
            textFieldConteiner.addArrangedSubview(stack)
            textFields.append(textField)
            
            label.snp.remakeConstraints { make in
                make.height.equalToSuperview().multipliedBy(0.25)
            }
            textField.snp.remakeConstraints { make in
                make.height.equalToSuperview().multipliedBy(0.55)
            }
        }
    }
    
    override func configure(object: RealmEditorDeteilModel) {
        self.textFields.forEach { field in
            switch field.fieldType {
            case .category: field.text = object.category
            case .type: field.text = object.type
            default: break
            }
        }
    }
    
    func createStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        stack.isLayoutMarginsRelativeArrangement = true
//        stack.contentMode = .scaleAspectFit
        stack.distribution = .fillProportionally
        stack.spacing = 10
        return stack
    }
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(size: 18, type: .medium)
        return label
    }
}

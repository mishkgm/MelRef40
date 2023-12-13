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
        stack.backgroundColor = AppConfig.Colors.deteilModsbuttonBackground
//        stack.layer.borderWidth = 1.5
//        stack.layer.borderColor = AppConfig.Colors.editorSelectorBorder.cgColor
        return stack
    }()
    
    private var textFields: [DeteilEditorTextField] = []
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.textFieldConteiner.setGradientBorder(width: 1, colors: [AppConfig.Colors.cellBorderColor, UIColor(hex: "#42535A")])
        }
    }
    
    override func configureView() {
        super.configureView()
        contentView.addSubview(textFieldConteiner)
    }
    
    override func makeConstraints() {
        textFieldConteiner.snp.remakeConstraints { make in
//            make.edges.equalToSuperview().inset()
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        model.types(for: .fields).forEach { item in
            let stack = createStack()
            let textField = DeteilEditorTextField(fieldType: item)
            let label = createLabel(text: item.displayName)
            
            textField.backgroundColor = UIColor(hex: "#BCC5C9")
            textField.layer.borderWidth = 1.5
            textField.layer.borderColor = UIColor(hex: "#F0D045").cgColor
            textField.textColor = .black
            textField.textAlignment = .center
            
            textField.delegate = self
            stack.addArrangedSubview(label)
            stack.addArrangedSubview(textField)
            textFieldConteiner.addArrangedSubview(stack)
            textFields.append(textField)
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
        stack.axis = .horizontal
        stack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.contentMode = .scaleAspectFit
        stack.distribution = .fillEqually
        return stack
    }
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(size: 16)
        return label
    }
}

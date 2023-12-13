//
//  SwitchCell.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 04.12.2023.
//

import Foundation
import UIKit
import SnapKit

final class SwitchCell<model: EditorCellModel>: EditorCell {
    
    lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.font = UIFont(size: 18, type: .medium)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Set file settings:"
        return label
    }()
    
    lazy var conteinerView: UIView = {
       var view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1.5
        view.layer.borderColor = AppConfig.Colors.cellBorderColor.cgColor
        view.backgroundColor = #colorLiteral(red: 0.2714084983, green: 0.4273136854, blue: 0.3375319242, alpha: 1)
        return view
    }()
    
    lazy var conteinerStack: UIStackView = {
       var view = UIStackView()
        view.spacing = 10
        view.axis = .vertical
        view.backgroundColor = .clear
        view.distribution = .fillEqually
        return view
    }()
    
    override func configureView() {
        super.configureView()
        contentView.addSubview(conteinerView)
        conteinerView.addSubview(titleLabel)
        conteinerView.addSubview(conteinerStack)
    }
    
    override func makeConstraints() {
        conteinerView.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        titleLabel.snp.remakeConstraints { make in
            make.trailing.leading.top.equalToSuperview().inset(12)
        }
        conteinerStack.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.bottom.trailing.leading.equalToSuperview().inset(12)
        }
        model.types(for: .switchCell).forEach { type in
            let view = DeteilEditorButton(editType: type, isSelect: type.rawValue == "true")
            view.changeValue = { [weak self] newValue in
                self?.updateData(data: newValue.0, type: newValue.1)
            }
            self.conteinerStack.addArrangedSubview(view)
        }
    }
    
    override func configure(object: RealmEditorDeteilModel) {
        self.conteinerStack.arrangedSubviews.forEach { view in
            guard let view = view as? DeteilEditorButton else { return }
            switch view.editType {
            case .canBeTaken:
                view.setState(for: object.canBeTaken)
            case .canBurn:
                view.setState(for: object.canBurn)
            case .canFloat:
                view.setState(for: object.canFloat)
            case .canGlow:
                view.setState(for: object.canGlow)
            default: break
            }
        }
    }
}

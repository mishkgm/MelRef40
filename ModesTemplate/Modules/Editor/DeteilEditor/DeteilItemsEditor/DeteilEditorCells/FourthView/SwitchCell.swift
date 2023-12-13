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
    
    lazy var conteinerView: DeteilStackView = {
       var view = DeteilStackView()
        view.backgroundColor = .clear
        view.spacing = 10
        return view
    }()
    
    override func configureView() {
        super.configureView()
        contentView.addSubview(conteinerView)
    }
    
    override func makeConstraints() {
        conteinerView.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        model.types(for: .switchCell).forEach { type in
            let view = CustomSwitchView(type: type)
            view.valueChanged = { [weak self] newValue in
                self?.updateData(data: newValue.0, type: newValue.1)
            }
            self.conteinerView.addView(view)
        }
    }
    
    override func configure(object: RealmEditorDeteilModel) {
        self.conteinerView.columnViews.forEach { view in
            guard let view = view as? CustomSwitchView else { return }
            switch view.type {
            case .canBeTaken:
                view.switchView.isOn = object.canBeTaken
            case .canBurn:
                view.switchView.isOn = object.canBurn
            case .canFloat:
                view.switchView.isOn = object.canFloat
            case .canGlow:
                view.switchView.isOn = object.canGlow
            default: break
            }
        }
    }
}

final class CustomSwitchView: BaseView {
    typealias NewValue = (Bool, EditorDataType)
    lazy var stackView: UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = isPad ? 30 : 10
        stack.backgroundColor = AppConfig.Colors.deteilModsbuttonBackground
        stack.distribution = .fillEqually
        stack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(size: 16)
        return label
    }()
    
    lazy var switchViewConteiner: UIView = {
       var view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var switchView: UISwitch = {
        var view = UISwitch()
         return view
    }()
    
    var valueChanged: ((NewValue) -> Void)?
    
    private(set) var type: EditorDataType
    
    init(type: EditorDataType) {
        self.type = type
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.stackView.setGradientBorder(width: 1, colors: [AppConfig.Colors.cellBorderColor, UIColor(hex: "#42535A")])
        }
    }
    
    override func configureView() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(switchViewConteiner)
        switchViewConteiner.addSubview(switchView)
        switchView.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        self.titleLabel.text = type.displayName
    }
    
    override func makeConstraints() {
        stackView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        switchView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        valueChanged?(NewValue(sender.isOn, type))
    }
}

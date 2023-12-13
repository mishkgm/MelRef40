//
//  DeteilEditorButton.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 30.11.2023.
//

import Foundation
import UIKit

class DeteilEditorButton: UIButton {
    typealias NewValue = (Bool, EditorDataType)
    
    lazy var title: UILabel = {
       var label = UILabel()
        label.textColor = .white
        label.font = UIFont(size: 18, type: .medium)
        return label
    }()
    
    lazy var stateTitle: UILabel = {
       var label = UILabel()
        label.textColor = .white
        label.font = UIFont(size: 16)
        return label
    }()
    
    func setState(for state: Bool = false) {
        stateTitle.textColor = state ? .white : .white
        stateTitle.text = state ? "Active" : "Disabled"
        isSelect = state
    }
    
    var changeValue: ((NewValue) -> Void)?
    
    private(set) var editType: EditorDataType
    private(set) var isSelect: Bool = false
    
    init(editType: EditorDataType, isSelect: Bool?) {
        self.editType = editType
        super.init(frame: .zero)
        self.setState(for: isSelect ?? false)
        addSubview(title)
        addSubview(stateTitle)
        stateTitle.snp.remakeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        title.snp.remakeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        title.text = editType.displayName
        self.addTarget(self, action: #selector(changeState), for: .touchUpInside)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func changeState() {
        self.isSelect.toggle()
        self.setState(for: isSelect)
    }
}

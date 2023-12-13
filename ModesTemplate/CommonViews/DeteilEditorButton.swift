//
//  DeteilEditorButton.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 30.11.2023.
//

import Foundation
import UIKit

class DeteilEditorButton: UIButton {
    
    lazy var title: UILabel = {
       var label = UILabel()
        label.textColor = .black
        return label
    }()
    
    lazy var stateTitle: UILabel = {
       var label = UILabel()
        label.textColor = .black
        return label
    }()
    
    func setState(for state: Bool = false) {
        stateTitle.textColor = state ? .black : .gray
        stateTitle.text = state ? "Active" : "disabled"
        isSelect = state
    }
    
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
        title.text = editType.rawValue

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

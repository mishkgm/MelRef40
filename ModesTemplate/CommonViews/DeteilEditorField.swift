//
//  DeteilEditorField.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 30.11.2023.
//

import Foundation
import UIKit
import RealmSwift

class DeteilEditorTextField: UITextField {
    
    var fieldType: EditorDataType
    
    var padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
    init(fieldType: EditorDataType) {
        self.fieldType = fieldType
        super.init(frame: .zero)
        self.font = UIFont(size: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

}

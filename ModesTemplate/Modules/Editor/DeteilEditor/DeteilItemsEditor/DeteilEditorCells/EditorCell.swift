//
//  EditorCell.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 04.12.2023.
//

import Foundation
import UIKit

protocol EditorCellModel: RawRepresentable<String> & CaseIterable {
    static func types(for type: EditorCellType) -> [EditorDataType]
}

enum EditorCellType: String, EditorCellModel {
    
    case name
    case icon
    case fields
    case coordinatesX
    case coordinatesW
    case slider
    case switchCell
    case titalCell
    
    var cell: EditorCell.Type {
        switch self {
        case .name:
            return NameTextFieldCell<Self>.self
        case .icon:
            return IconUploadCell<Self>.self
        case .fields:
            return FieldCell<Self>.self
        case .coordinatesX:
            return CoordinateFieldCellX<Self>.self
        case .coordinatesW:
            return CoordinateFieldCellW<Self>.self
        case .slider:
            return SliderViewCell<Self>.self
        case .switchCell:
            return SwitchCell<Self>.self
        case .titalCell:
            return TitleCell.self
        }
    }
    
    var heightForRow: CGFloat {
        switch self {
        case .name:
            return 75
        case .icon:
            return 240
        case .fields:
            return 170
        case .coordinatesX:
            return 60
        case .coordinatesW:
            return 60
        case .slider:
            return 120
        case .switchCell:
            return 400
        case .titalCell:
            return 70
        }
    }
    
    static func types(for type: EditorCellType) -> [EditorDataType] {
        switch type {
        case .name:
            return [.name]
        case .icon:
            return [.iconData]
        case .fields:
            return [.type, .category]
        case .coordinatesX:
            return [.xValue, .yValue]
        case .coordinatesW:
            return [.widthValue, .heightValue]
        case .slider:
            return [.pixelValue]
        case .switchCell:
            return [.canBurn, .canBeTaken, .canFloat, .canGlow]
        case .titalCell:
            return []
        }
    }
}

class EditorCell: BaseTableViewCell {
    
    weak var updater: EditorDataUpdate?
    
    var openImagePicker: (() -> Void)?
    
    override func configureView() {
        backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.layoutSubviews()
    }
    
    func configure(object: RealmEditorDeteilModel) {
        
    }
    
    func updateData(data: Any, type: EditorDataType) {
        updater?.updateData(type: type, newValue: data)
    }
}

extension EditorCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let textField = textField as? DeteilEditorTextField {
            self.updateData(data: textField.text ?? "", type: textField.fieldType)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textField = textField as? DeteilEditorTextField else { return true }
        switch textField.fieldType {
        case .xValue, .yValue, .widthValue, .heightValue:
            let allowedCharacterSet = CharacterSet(charactersIn: "0123456789")
            
            let stringCharacterSet = CharacterSet(charactersIn: string)
            let isCharacterAllowed = allowedCharacterSet.isSuperset(of: stringCharacterSet)
            
            return isCharacterAllowed
        default: return true
        }
    }
}

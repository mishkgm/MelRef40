//
//  DeteilEditorViewModel.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 30.11.2023.
//

import Foundation
import RealmSwift

protocol EditorDataUpdate: AnyObject {
    func updateData(type: EditorDataType, newValue: Any)
}

enum EditorDataType: String {
        
    case name
    case type
    case category
    case iconData
    
    case xValue
    case yValue
    case heightValue
    case widthValue
    
    case pixelValue
    case canBeTaken
    case canGlow
    case canBurn
    case canFloat
    
    var displayName: String {
        switch self {
        case .name:
            return "Name"
        case .type:
            return "Time style"
        case .category:
            return "Category"
        case .iconData:
            return "Icon"
        case .xValue:
            return " X: "
        case .yValue:
            return " Y: "
        case .heightValue:
            return "H: "
        case .widthValue:
            return "W: "
        case .pixelValue:
            return " Pixel Per Unit".uppercased()
        case .canBeTaken:
            return "Can be taken:"
        case .canGlow:
            return "Can glow:"
        case .canBurn:
            return "Can burn:"
        case .canFloat:
            return "Can float:"
        }
    }
}

protocol DeteilEditorViewModelDelegate: AnyObject {
    func saveAction()
    func showNoNameAlert()
    func nothingToSave()
}

final class DeteilEditorViewModel {
    
    private var defaultObject: RealmEditorDeteilModel
    private(set) var object: RealmEditorDeteilModel
    
    weak var delegate: DeteilEditorViewModelDelegate?
    
    init(object: RealmEditorDeteilModel) {
        self.defaultObject = RealmEditorDeteilModel(editorDeteilModel: EditorDeteilModel(realmModel: object))
        self.object = object
    }
    
    func saveMod() {
        if defaultObject.isDataEqual(rhs: object) {
            delegate?.nothingToSave()
            return
        } else if object.name.replacingOccurrences(of: " ", with: "").isEmpty {
            delegate?.showNoNameAlert()
            return 
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if RealmManager.shared.getObject(RealmEditorDeteilModel.self, forKey: self.object.primaryKey) == nil {
                RealmManager.shared.create(self.object)
            } else {
                RealmManager.shared.resaveMod(self.object)
            }
            self.delegate?.saveAction()
        }
    }
    
    func updateIcon(data: Data?) {
        guard let data = data else { return }
        self.object.iconData = data
    }
    
    func updateImage(data: Data?) {
        guard let data = data else { return }
        self.object.imageData = data
    }
}

extension DeteilEditorViewModel: EditorDataUpdate {
    func updateData(type: EditorDataType, newValue: Any) {
        switch type {
        case .name, .type, .category, .xValue, .yValue, .widthValue, .heightValue, .pixelValue:
            guard let newValue = newValue as? String else { return }
            RealmManager.shared.update(object, with: [type.rawValue: newValue])
        case .canBeTaken, .canGlow, .canBurn, .canFloat:
            guard let newValue = newValue as? Bool else { return }
            RealmManager.shared.update(object, with: [type.rawValue: newValue])
        default:
            break
        }
    }
}

private extension DeteilEditorViewModel {
    func stringToBool(string: String) -> Bool {
        if string == "true" {
            return true
        } else {
            return false
        }
    }
}

//
//  DeteilEditorModel.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 30.11.2023.
//

import Foundation
import RealmSwift

class RealmEditorDeteilModel: Object {
    
    @Persisted(primaryKey: true) var primaryKey: String = ""
    @Persisted var name: String = ""
    @Persisted var imageData: Data
    @Persisted var type: String = ""
    @Persisted var category: String = ""
    @Persisted var iconData: Data
    
    @Persisted var xValue: String = ""
    @Persisted var yValue: String = ""
    @Persisted var heightValue: String = ""
    @Persisted var widthValue: String = ""
    
    @Persisted var pixelValue: String = ""
    
    @Persisted var canBeTaken: Bool = false
    @Persisted var canGlow: Bool = false
    @Persisted var canBurn: Bool = false
    @Persisted var canFloat: Bool = false
    
    @Persisted var createdData: Date = Date()
    
    convenience init(name: String, imageData: Data, type: String, category: String, xValue: String, yValue: String, heightValue: String, widthValue: String, pixelValue: String, canBeTaken: Bool, canGlow: Bool, canBurn: Bool, canFloat: Bool) {
        self.init()
        self.primaryKey = UUID().uuidString
        self.name = name
        self.imageData = imageData
        self.iconData = imageData
        self.type = type
        self.category = category
        self.xValue = xValue
        self.yValue = yValue
        self.heightValue = heightValue
        self.widthValue = widthValue
        self.pixelValue = pixelValue
        self.canBeTaken = canBeTaken
        self.canGlow = canGlow
        self.canBurn = canBurn
        self.canFloat = canFloat
    }
    
    convenience init(editorDeteilModel: EditorDeteilModel) {
        self.init()
        self.primaryKey = editorDeteilModel.realmKey
        self.name = editorDeteilModel.name
        self.imageData = editorDeteilModel.imageData ?? Data()
        self.iconData = editorDeteilModel.iconData ?? Data()
        self.type = editorDeteilModel.type
        self.category = editorDeteilModel.category
        self.xValue = editorDeteilModel.xValue
        self.yValue = editorDeteilModel.yValue
        self.heightValue = editorDeteilModel.heightValue
        self.widthValue = editorDeteilModel.widthValue
        self.pixelValue = editorDeteilModel.pixelValue
        self.canBeTaken = editorDeteilModel.canBeTaken
        self.canGlow = editorDeteilModel.canGlow
        self.canBurn = editorDeteilModel.canBurn
        self.canFloat = editorDeteilModel.canFloat
    }
}

extension RealmEditorDeteilModel {
    
    func isDataEqual(rhs: RealmEditorDeteilModel) -> Bool {
        let lhs = self
                return lhs.name == rhs.name &&
                lhs.imageData == rhs.imageData &&
                lhs.type == rhs.type &&
                lhs.category == rhs.category &&
                lhs.xValue == rhs.xValue &&
                lhs.yValue == rhs.yValue &&
                lhs.heightValue == rhs.heightValue &&
                lhs.widthValue == rhs.widthValue &&
                lhs.pixelValue == rhs.pixelValue &&
                lhs.canBeTaken == rhs.canBeTaken &&
                lhs.canGlow == rhs.canGlow &&
                lhs.canBurn == rhs.canBurn &&
                lhs.canFloat == rhs.canFloat &&
                lhs.iconData == rhs.iconData
    }
}

struct EditorDeteilModel {
    var realmKey: String
    var name: String
    var imageData: Data?
    var iconData: Data?
    var type: String
    var category: String

    var xValue: String
    var yValue: String
    var heightValue: String
    var widthValue: String

    var pixelValue: String

    var canBeTaken: Bool = false
    var canGlow: Bool = false
    var canBurn: Bool = false
    var canFloat: Bool = false
    
    var createdDate: Date
    
    init(realmModel: RealmEditorDeteilModel) {
        self.realmKey = realmModel.primaryKey
        self.name = realmModel.name
        self.imageData = realmModel.imageData
        self.iconData = realmModel.iconData
        self.type = realmModel.type
        self.category = realmModel.category
        self.xValue = realmModel.xValue
        self.yValue = realmModel.yValue
        self.heightValue = realmModel.heightValue
        self.widthValue = realmModel.widthValue
        self.pixelValue = realmModel.pixelValue
        self.canBeTaken = realmModel.canBeTaken
        self.canGlow = realmModel.canGlow
        self.canBurn = realmModel.canBurn
        self.canFloat = realmModel.canFloat
        self.createdDate = realmModel.createdData
    }
}

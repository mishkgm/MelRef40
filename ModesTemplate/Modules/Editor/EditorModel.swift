//
//  EditorModel.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 30.11.2023.
//

import Foundation
import RealmSwift

struct EditorContentModel {
    var realmKey: String
    var imagePath: String
    var imageData: Data?
    var contentType: EditorContentType
    
    init(item: RealmEditorContentModel) {
        self.realmKey = item.primaryKey
        self.imagePath = item.imagePath
        self.imageData = item.imageData
        self.contentType = EditorContentType(rawValue: item.contentType) ?? .living
    }
}

class RealmEditorContentModel: Object {
    @Persisted(primaryKey: true) var primaryKey: String = ""
    @Persisted var imagePath: String
    @Persisted var imageData: Data?
    @Persisted var contentType: String
    
    convenience init(imagePath: String, imageData: Data? = nil, contentType: EditorContentType) {
        self.init()
        self.primaryKey = UUID().uuidString
        self.imagePath = imagePath
        self.imageData = imageData
        self.contentType = contentType.rawValue
    }
    
    convenience init(item: EditorContentModel) {
        self.init()
        self.primaryKey = UUID().uuidString
        self.imagePath = item.imagePath
        self.imageData = item.imageData
    }
}

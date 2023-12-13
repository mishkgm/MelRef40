//
//  ModsModel.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 26.11.2023.
//

import Foundation
import RealmSwift

class RealmModsModel: Object {
    @Persisted(primaryKey: true) var primaryKey: String = ""
    @Persisted var title: String = ""
    @Persisted var descriptionText: String = ""
    @Persisted var downloadPath: String = ""
    @Persisted var category: String = ""
    @Persisted var imagePath: String = ""
    @Persisted var imageData: Data?
    @Persisted var isFavourite: Bool = false
    
    convenience init(title: String, description: String, downloadPath: String, category: String, imagePath: String, imageData: Data?) {
        self.init()
        self.primaryKey = UUID().uuidString
        self.title = title
        self.descriptionText = description
        self.downloadPath = downloadPath
        self.category = category
        self.imagePath = imagePath
        self.imageData = imageData
    }
}

struct ModsModel {
    let realmKey: String
    let title: String
    let description: String
    let downloadPath: String
    let category: String
    let imagePath: String
    var imageData: Data?
    var isFavourite: Bool
    
    init(realmModsModel: RealmModsModel) {
        self.title = realmModsModel.title
        self.description = realmModsModel.descriptionText
        self.downloadPath = realmModsModel.downloadPath
        self.category = realmModsModel.category
        self.imagePath = realmModsModel.imagePath
        self.imageData = realmModsModel.imageData
        self.realmKey = realmModsModel.primaryKey
        self.isFavourite = realmModsModel.isFavourite
    }
}

class RealmCategoriesModel: Object {
    @Persisted(primaryKey: true) var realmKey: String = ""
    @Persisted var title: String = ""
    @Persisted var imagePath: String = ""
    @Persisted var imageData: Data?

    convenience init(title: String, imagePath: String, imageData: Data? = nil) {
        self.init()
        self.realmKey = UUID().uuidString
        self.title = title
        self.imagePath = imagePath
        self.imageData = imageData
    }
}

struct CategoriesModel {
    let realmKey: String
    let title: String
    let imagePath: String
    var imageData: Data?

    init(realmCategoriewModel: RealmCategoriesModel) {
        self.realmKey = realmCategoriewModel.realmKey
        self.title = realmCategoriewModel.title
        self.imagePath = realmCategoriewModel.imagePath
        self.imageData = realmCategoriewModel.imageData
    }
}

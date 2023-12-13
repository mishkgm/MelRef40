//
//  ItemsModel.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 26.11.2023.
//

import Foundation
import RealmSwift

class RealmItemsModel: Object {
    @Persisted(primaryKey: true) var primaryKey: String = ""
    @Persisted var title: String = ""
    @Persisted var descriptionText: String = ""
    @Persisted var imagePath: String = ""
    @Persisted var imageData: Data?
    @Persisted var type: String
    @Persisted var isFavourite: Bool
    @Persisted var downloadPath: String
    
    convenience init(title: String, description: String, imagePath: String, imageData: Data? = nil, type: String, downloadPath: String) {
        self.init()
        self.title = title
        self.descriptionText = description
        self.imagePath = imagePath
        self.imageData = imageData
        self.type = type
        self.downloadPath = downloadPath
        self.primaryKey = UUID().uuidString
    }

    convenience init(itemsModel: ItemsModel) {
        self.init()
        self.title = itemsModel.title
        self.descriptionText = itemsModel.description
        self.imagePath = itemsModel.imagePath
        self.imageData = itemsModel.imageData
        self.type = itemsModel.type.rawValue
        self.downloadPath = itemsModel.downloadPath
        self.primaryKey = UUID().uuidString
    }
}

struct ItemsModel {
    let realmKey: String
    var title: String
    var description: String
    var imagePath: String
    var imageData: Data?
    var isFavourite: Bool = false
    var downloadPath: String
    var type: ContentType

    init(realmItemsModel: RealmItemsModel) {
        self.realmKey = realmItemsModel.primaryKey
        self.title = realmItemsModel.title
        self.description = realmItemsModel.descriptionText
        self.imagePath = realmItemsModel.imagePath
        self.imageData = realmItemsModel.imageData
        self.isFavourite = realmItemsModel.isFavourite
        self.downloadPath = realmItemsModel.downloadPath
        self.type = ContentType(rawValue: realmItemsModel.type) ?? .items
    }
}

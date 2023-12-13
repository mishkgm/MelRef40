//
//  DropBoxClient.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 23.11.2023.
//

import Foundation
import SwiftyDropbox
import RealmSwift
import PromiseKit

// MARK: - ContentTypes from DropBox
enum ContentType: String {
    case mods = "Mods"
    case category = "Category"
    case editor = "Editor"
    case items = "Items"
    case skins = "Skins"
    
    // paths to json file
    var downloadPath: String {
        switch self {
        case .mods: return "/Content/content.json"
        case .category: return "/categories/categories.json"
        case .editor: return "/mod_editor/mod_editor.json"
        case .items: return "/Items/Modified_Items.json"
        case .skins: return "/Skins/Modified_Skins.json"
        }
    }
    
    var folderName: String {
        switch self{
        case .mods:
            return "Content"
        case .items:
            return "Items"
        case .skins:
            return "Skins"
        default: return ""
        }
    }
}

final class DropBoxClient {
    
    // MARK: - Private 
    private let core = DropBoxCore()
    private let realm = RealmManager.shared
    private let userDefaults = UserDefaults.standard
    private let fileManager = FileManager.default
    private let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    // MARK: - Public
    public static let shared = DropBoxClient()
    
    public func start() -> Promise<Void> {
        return Promise { complition in
            firstly {
                core.initDropBox()
            }.done { _ in
                complition.fulfill(())
            }.catch { error in
                complition.reject(error)
            }
        }
    }
    
    public func getContentFor(type: ContentType) -> Promise<Void> {
        return Promise<Void> { complition in
            checkUpdatesFor(type: type).done { isNew in
                if isNew {
                    complition.fulfill(())
                } else {
                    self.downloadStructJson(type: type).done {
                        complition.fulfill(())
                    }.catch { error in
                        complition.reject(error)
                    }
                }
            }.catch { error in
                complition.reject(error)
            }
        }
    }
    
    public func downloadImage(imagePath: String) -> Promise<String?> {
        return Promise<String?> { [weak self] complition in
            self?.core.client?.files.getTemporaryLink(path: "\(imagePath)").response(completionHandler: { responce, error in
                if let link = responce {
                    complition.fulfill(link.link)
                } else {
                    complition.reject(DropError.downlaodImageError(imagePath: imagePath))
                }
            })
        }
    }
    
    public func downloadAndSaveMod(at path: String) -> Promise<URL?> {
        
        let folderName = String(path.split(separator: "/")[0])
        let dirPath = directoryURL.appendingPathComponent(folderName)
        
        let dest = directoryURL.appendingPathComponent(path)
        let destURL = directoryURL.appendingPathComponent(dest.lastPathComponent)
        
        let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
            return destURL
        }
        
        return Promise<URL?> { complition in
            firstly {
                createDirectoryIfNeeded(at: dirPath)
            }.then {
                self.downloadMod(path: path, destination: destination)
            }.done { response in
                complition.fulfill(response)
            }.catch { error in
                complition.reject(error)
            }
        }
    }
}

// MARK: - Private extension
private extension DropBoxClient {
    
    enum DropError: Error {
        case checkUpdateError(type: ContentType, errorDescription: String)
        case downloadError(type: ContentType)
        case parseError(type: ContentType)
        case downlaodImageError(imagePath: String)
        case downloadFileError(path: String)
        case someError(message: String)
        case unknownError
    }
    
    func checkUpdatesFor(type: ContentType) -> Promise<Bool> {
        return Promise<Bool> { complition in
            core.client?.files.getMetadata(path: type.downloadPath).response(completionHandler: { data, error in
                if let data = data as? Files.FileMetadata {
                    if data.size == self.userDefaults.integer(forKey: "bytes\(type.rawValue)") {
                        complition.fulfill(true)
                    } else {
                        self.userDefaults.set(Int(data.size), forKey: "bytes\(type.rawValue)")
                        complition.fulfill(false)
                    }
                } else if let error = error {
                    complition.reject(DropError.checkUpdateError(type: type, errorDescription: error.description))
                } else {
                    complition.reject(DropError.unknownError)
                }
            })
        }
    }
    
    func downloadStructJson(type: ContentType) -> Promise<Void> {
        return Promise<Void> { complition in
            core.client?.files.download(path: type.downloadPath).response(completionHandler: { response, error in
                guard error == nil, let response = response else {
                    complition.reject(DropError.downloadError(type: type))
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: response.1, options: [])
                    let dictionary = json as? [String: Any]
                    try self.featchContent(type: type, response: dictionary ?? [:])
                    complition.fulfill(())
                } catch {
                    complition.reject(error)
                }
            })
        }
    }
    
    func downloadMod(path: String, destination: @escaping (URL, HTTPURLResponse) -> URL) -> Promise<URL?> {
        return Promise { complition in
            self.core.client?.files.download(path: "/\(path)", overwrite: true, destination: destination).response(completionHandler: { response, error in
                guard error == nil, let response = response else {
                    complition.reject(DropError.downloadFileError(path: path))
                    return
                }
                complition.fulfill(response.1)
            })
        }
    }
    
    func createDirectoryIfNeeded(at url: URL) -> Promise<Void> {
        return Promise { seal in
            if !fileManager.fileExists(atPath: url.path) {
                do {
                    try fileManager.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
                    seal.fulfill(())
                } catch {
                    print(error)
                    seal.reject(error)
                }
            } else {
                seal.fulfill(())
            }
        }
    }
}

// MARK: - Private extension content featch
private extension DropBoxClient {
    
    func featchContent(type: ContentType, response: [String: Any]) throws {
        switch type {
        case .mods:
            try featchMods(json: response)
        case .category:
            try featchCategory(json: response)
        case .editor:
            try featchEditor(json: response)
        case .items:
            try featchItems(json: response)
        case .skins:
            try featchSkins(json: response)
        }
    }
    
    func featchMods(json: [String: Any]) throws {
        guard let structJson = json[ModsJsonKeys.main] as? [String: Any] else {
            throw DropError.parseError(type: .mods)
        }
        self.realm.deleteAllOfType(RealmModsModel.self)
        for key in structJson.keys {
            if let model = structJson[key] as? [[String: Any]] {
                try model.forEach { object in
                    guard let title = object[ModsJsonKeys.title] as? String,
                          let description = object[ModsJsonKeys.description] as? String,
                          let imagePath = object[ModsJsonKeys.imagePath] as? String,
                          let downloadPath = object[ModsJsonKeys.downloadPath] as? String else {
                        throw DropError.parseError(type: .mods)
                    }
                    self.realm.create(RealmModsModel(title: title, description: description, downloadPath: downloadPath, category: key, imagePath: imagePath, imageData: nil))
                }
            } else {
                throw DropError.parseError(type: .mods)
            }
        }
    }
    
    func featchCategory(json: [String: Any]) throws {
        guard let structJson = json[CategoriesJsonKeys.main] as? [[String: String]] else {
            throw DropError.parseError(type: .category)
        }
        try structJson.forEach { objct in
            guard let title = objct[CategoriesJsonKeys.title],
                  let imagePath = objct[CategoriesJsonKeys.imagePath] else {
                throw DropError.parseError(type: .category)
            }
            self.realm.create(RealmCategoriesModel(title: title, imagePath: imagePath))
        }
    }
    
    func featchEditor(json: [String: Any]) throws {
        guard let structJson = json[EditorJsonKeys.main] as? [String: Any] else {
            throw DropError.parseError(type: .editor)
        }
        for key in structJson.keys {
            if let objectJson = structJson[key] as? [[String: Any]] {
                objectJson.forEach { object in
                    if let imagePath = object[EditorJsonKeys.imagePath] as? String {
                        self.realm.create(RealmEditorContentModel(imagePath: imagePath, contentType: Bool.random() ? .living : .miscTemplate))
                    }
                }
            }
        }
    }
    
    func featchItems(json: [String: Any]) throws {
        guard let structJson = json[ItemsJsonKeys.main] as? [[String: String]] else {
            throw DropError.parseError(type: .items)
        }
        try structJson.forEach { objct in
            guard let title = objct[ItemsJsonKeys.title],
                  let description = objct[ItemsJsonKeys.description],
                  let imagePath = objct[ItemsJsonKeys.imagePath],
                  let downloadPath = objct[ItemsJsonKeys.downloadPath] else {
                throw DropError.parseError(type: .items)
            }
            self.realm.create(RealmItemsModel(title: title, description: description, imagePath: imagePath, type: ItemsType.items.rawValue, downloadPath: downloadPath))
        }
    }
    
    func featchSkins(json: [String: Any]) throws {
        guard let structJson = json[SkinsJsonKeys.main] as? [[String: String]] else {
            throw DropError.parseError(type: .skins)
        }
        try structJson.forEach { objct in
            guard let title = objct[SkinsJsonKeys.title],
                  let description = objct[SkinsJsonKeys.description],
                  let imagePath = objct[SkinsJsonKeys.imagePath],
                  let downloadPath = objct[SkinsJsonKeys.downloadPath] else {
                throw DropError.parseError(type: .skins)
            }
            self.realm.create(RealmItemsModel(title: title, description: description, imagePath: imagePath, type: ItemsType.skins.rawValue, downloadPath: downloadPath))
        }
    }
}

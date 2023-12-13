//
//  DeteilViewModel.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 28.11.2023.
//

import Foundation
import PromiseKit
import UIKit
import RealmSwift

protocol DeteilViewModelDelegate: AnyObject {
    func showActivityView(url: URL?)
    func customAlert()
}

final class DeteilViewModel {
    
    private(set) var model: DeteilModel
    private(set) var type: ContentType
    
    private let dropBox = DropBoxClient.shared
    private let fileManager = FileManager.default
    private let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    weak var delegate: DeteilViewModelDelegate?
    
    init(model: DeteilModel, type: ContentType) {
        self.model = model
        self.type = type
        print(model)
    }
    
    func toggleFavouriteStatus() {
        self.model.isFavourite.toggle()
        if let obcjet = RealmManager.shared.getObject(RealmItemsModel.self, forKey: model.realmKey) {
            RealmManager.shared.update(obcjet, with: ["isFavourite": self.model.isFavourite])
        } else if let obcjet = RealmManager.shared.getObject(RealmModsModel.self, forKey: model.realmKey) {
            RealmManager.shared.update(obcjet, with: ["isFavourite": self.model.isFavourite])
        }
    }
    
    func checkIfFileExist() -> Bool {
        let dest = directoryURL.appendingPathComponent(model.downloadPath)
        let destURL = directoryURL.appendingPathComponent(dest.lastPathComponent)
        if fileManager.fileExists(atPath: destURL.path) {
            return true
        } else {
            return false
        }
    }
    
    func downloadImage(imageView: UIImageView) {
        firstly {
            self.dropBox.downloadImage(imagePath: "/Content/\(model.imagePath)")
        }.then { urlString in
            imageView.setImage(with: urlString)
        }.done { _ in
            
        }.catch { error in
            print(error)
        }
    }
    
    func getFileUrl() -> URL {
        let dest = directoryURL.appendingPathComponent(model.downloadPath)
        return directoryURL.appendingPathComponent(dest.lastPathComponent)
    }
    
    func shareMod() {
        self.delegate?.showActivityView(url: getFileUrl())
    }
    
    func downloadMod() {
        firstly {
            dropBox.downloadAndSaveMod(at: "\(type.folderName)/\(model.downloadPath)")
        }.done { url in
            self.delegate?.customAlert()
        }.catch { error in
            print(error)
        }
    }
}

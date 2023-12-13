//
//  ItemViewModel.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 26.11.2023.
//

import Foundation
import UIKit
import PromiseKit

final class ItemsViewModel: BaseViewModel {
    
    var isFavouriteSetup: Bool = false
    // Private
    private(set) var model: [ItemsModel] = []
    
    func downloadImage(index: Int, imageView: UIImageView) {
        let item = model[index]
        guard item.imageData == nil,
            let objct = self.realm.getObject(RealmItemsModel.self, forKey: item.realmKey) else { return }
        firstly {
            self.downloadImage(imagePath: "/\(contentType.folderName)/\(objct.imagePath)", object: objct, imageView: imageView)
        }.done { data in
            guard self.model.count > index else { return }
            self.model[index].imageData = data
        }.catch { error in
            print("\(error)")
        }
    }
    
    func toggleFavouriteStatus(index: Int) {
        let itemKey = model[index].realmKey
        guard let objct = self.realm.getObject(RealmItemsModel.self, forKey: itemKey) else { return }
        self.model[index].isFavourite.toggle()
        self.realm.update(objct, with: ["isFavourite": model[index].isFavourite])
        isFavouriteSetup ? featchData() : ()
    }
    
    func updateContent() {
        featchData() // preload old data 
        firstly {
            getContent()
        }.done { _ in
            self.featchData()
        }.catch { error in
            print("\(error)")
        }
    }
    
    func downloadMod(index: Int) {
        firstly {
            dropBox.downloadAndSaveMod(at: "\(contentType.folderName)/\(model[index].downloadPath)")
        }.done { url in
            self.delegate?.showCustomAlert(style: .saved)
        }.catch { error in
            self.delegate?.showCustomAlert(style: .error)
            print(error)
        }
    }
}

private extension ItemsViewModel {
    func featchData() {
        self.model = []
        realm.read(type: RealmItemsModel.self)?.forEach({ model in
            if ContentType(rawValue: model.type) == self.contentType {
                self.model.append(ItemsModel(realmItemsModel: model))
            }
        })
        if isFavouriteSetup {
            self.model = model.filter({ $0.isFavourite })
            if  model.filter({ $0.isFavourite }).isEmpty {
                delegate?.isEmtyCollection(true)
            } else {
                delegate?.isEmtyCollection(false)
            }
        }
        self.delegate?.reloadData()
    }
}

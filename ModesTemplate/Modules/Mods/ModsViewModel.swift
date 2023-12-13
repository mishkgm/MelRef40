//
//  ModsViewModel.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 26.11.2023.
//

import Foundation
import PromiseKit
import UIKit

enum CurrentState: Equatable {
    case common
    case favourite
    case search(text: String)
    case all
}

final class ModsViewModel: BaseViewModel {
    
    // Private
    private(set) var currentState: CurrentState = .common {
        didSet {
            self.delegate?.reloadData()
        }
    }
    private(set) var categoryModel: [CategoriesModel] = []
    private(set) var currentCategory: CategoriesModel? {
        didSet {
            delegate?.reloadData()
        }
    }
    private var modsModel: [ModsModel] = []
    
    override func getContent() -> Promise<Void> {
        return Promise { comlition in
            firstly {
                dropBox.getContentFor(type: .mods)
            }.then { _ in
                self.dropBox.getContentFor(type: .category)
            }.done { _ in
                comlition.fulfill(())
            }.catch { error in
                comlition.reject(error)
            }
        }
    }
    
    func currentModel() -> [ModsModel] {
        switch currentState {
        case .common: return modsModel.filter({ $0.category == currentCategory?.title })
        case .favourite:
            
            guard !modsModel.filter({ $0.isFavourite }).isEmpty else {
                delegate?.isEmtyCollection(true)
                return []
            }
            delegate?.isEmtyCollection(false)
            return modsModel.filter({ $0.isFavourite })
            
        case .search(let text):
            return modsModel.filter( { $0.title.replacingOccurrences(of: " ", with: "").lowercased().contains(text.lowercased())} )
        case .all:
            return modsModel
        }
    }
    
    func selectCategory(category: CategoriesModel) {
        self.currentCategory = category
    }
    
    func setCurrentState(state: CurrentState) {
        self.currentState = state
    }
    
    func togleFavouriteStatus(for index: Int) {
        let itemKey = self.currentModel()[index].realmKey
        guard let itemIndex = modsModel.firstIndex(where: { $0.realmKey == itemKey }),
              let objct = self.realm.getObject(RealmModsModel.self, forKey: itemKey) else { return }
        self.modsModel[itemIndex].isFavourite.toggle()
        self.realm.update(objct, with: ["isFavourite": modsModel[itemIndex].isFavourite])
        currentState == .favourite ? self.delegate?.reloadData() : ()
    }
    
    func downloadImage(key: String, imageView: UIImageView) {
        guard let index = modsModel.firstIndex(where: { $0.realmKey == key }) else {
            return
        }
        let item = modsModel[index]
        guard item.imageData == nil,
            let objct = self.realm.getObject(RealmModsModel.self, forKey: item.realmKey) else { return }
        firstly {
            self.downloadImage(imagePath: "/Content/\(objct.imagePath)", object: objct, imageView: imageView)
        }.done { [weak self] data in
            self?.modsModel[index].imageData = data
        }.catch { error in
            print("\(error)")
        }
    }
    
    func updateContent() {
        featchData()
        firstly {
            self.getContent()
        }.done { [weak self] _ in
            self?.featchData()
        }.catch { error in
            print("Error \(self.contentType): \(error)")
        }
    }
}

private extension ModsViewModel {
    func featchData() {
        self.categoryModel = []
        self.modsModel = []
        realm.read(type: RealmCategoriesModel.self)?.forEach({ model in
            self.categoryModel.append(CategoriesModel(realmCategoriewModel: model))
        })
        realm.read(type: RealmModsModel.self)?.forEach({ model in
            self.modsModel.append(ModsModel(realmModsModel: model))
        })
        self.categoryModel.sort(by: { $0.title < $1.title})
        self.modsModel.sort(by: { $0.title < $1.title})
//        if IAPManager_MWP.shared.productBought.contains(.unlockContentProduct) {
//            self.selectCategory(category: categoryModel[1])
//        } else {
            self.selectCategory(category: categoryModel[0])
//        }
        self.delegate?.reloadData()
    }
}

//
//  EditroViewModel.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 30.11.2023.
//

import Foundation
import PromiseKit
import UIKit

final class EditorViewModel: BaseViewModel {
    
    private(set) var model: [EditorContentModel] = []
    private(set) var currentSelectedType: EditorContentType = .miscTemplate
    
    func downloadImage(key: String, imageView: UIImageView) {
        guard let index = model.firstIndex(where: { $0.realmKey == key }) else {
            return
        }
        let item = model[index]
        guard item.imageData == nil,
            let objct = self.realm.getObject(RealmEditorContentModel.self, forKey: item.realmKey) else { return }
        firstly {
            self.downloadImage(imagePath: "/\(objct.imagePath)", object: objct, imageView: imageView)
        }.done { [weak self] data in
            self?.model[index].imageData = data
        }.catch { error in
            print("\(error)")
        }
    }
    
    func getCurrentModel() -> [EditorContentModel] {
        return model.filter({ $0.contentType == currentSelectedType })
    }
    
    func selectContentType(type: EditorContentType) {
        self.currentSelectedType = type
        delegate?.reloadData()
    }
    
    func updateContent() {
        featchData()
        firstly {
            getContent()
        }.done { _ in
            self.featchData()
            self.delegate?.reloadData()
        }.catch { error in
            print(error)
        }
    }
}

private extension EditorViewModel {
    func featchData() {
        self.model = []
        realm.read(type: RealmEditorContentModel.self)?.forEach({ model in
            self.model.append(EditorContentModel(item: model))
        })
        self.delegate?.reloadData()
    }
}

//
//  MyWorksViewModel.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 30.11.2023.
//

import Foundation
import UIKit

protocol MyWorksViewModelDelegate: AnyObject {
    func reloadData()
}

final class MyWorksViewModel {
    private(set) var model: [EditorDeteilModel] = []
    
    weak var delegate: MyWorksViewModelDelegate?
    
    func feathcData() {
        self.model = []
        RealmManager.shared.read(type: RealmEditorDeteilModel.self)?.forEach({ item in
            model.append(EditorDeteilModel(realmModel: item))
        })
        self.delegate?.reloadData()
    }
    
    func deleteMod(index: Int) {
        let item = self.model[index]
        if let object = RealmManager.shared.getObject(RealmEditorDeteilModel.self, forKey: item.realmKey) {
            RealmManager.shared.delete(object)
        }
        self.model.remove(at: index)
        self.delegate?.reloadData()
    }
}

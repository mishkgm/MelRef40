//
//  RealmCore.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 23.11.2023.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    
    private var realm: Realm? {
        do {
            return try Realm()
        } catch let error as NSError {
            print("Ошибка инициализации Realm: \(error.description)")
            return nil
        }
    }

    private init() {}

    // MARK: - Create
    func create<T: Object>(_ object: T) {
// TEXT FOR APPREFACTORING
        do {
            try realm?.write {
                realm?.add(object)
            }
        } catch let error as NSError {
            print("Ошибка создания объекта: \(error.description)")
        }
    }
    
    // MARK: - Read
    func read<T: Object>(type: T.Type) -> Results<T>? {
// TEXT FOR APPREFACTORING
        return realm?.objects(type)
    }

    // MARK: - Update
    func update<T: Object>(_ object: T, with dictionary: [String: Any?]) {
// TEXT FOR APPREFACTORING
        do {
            try realm?.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch let error as NSError {
            print("Ошибка обновления объекта: \(error.description)")
        }
    }

    // MARK: - Delete
    func delete<T: Object>(_ object: T) {
// TEXT FOR APPREFACTORING
        do {
            try realm?.write {
                realm?.delete(object)
            }
        } catch let error as NSError {
            print("Ошибка удаления объекта: \(error.description)")
        }
    }

    // MARK: - Delete All
    func deleteAll() {
// TEXT FOR APPREFACTORING FUNC
        do {
            try realm?.write {
                realm?.deleteAll()
            }
        } catch let error as NSError {
            print("Ошибка удаления всех объектов: \(error.description)")
        }
    }
    
    // MARK: - Delete All of type
    func deleteAllOfType<T: Object>(_ type: T.Type) {
// TEXT FOR APPREFACTORING
        do {
            try realm?.write {
                if let objects = realm?.objects(type) {
                    realm?.delete(objects)
                }
            }
        } catch let error as NSError {
            print("Ошибка удаления всех объектов типа \(type): \(error.description)")
        }
    }
    
    func resaveMod<T: Object>(_ item: T) {
        // TEXT FOR APPREFACTORING
        do {
            try realm?.write {
                realm?.add(item, update: .all)
            }
        } catch let error as NSError {
            print(error)
        }
    }
    // MARK: - Get Object by Key
    func getObject<T: Object>(_ type: T.Type, forKey key: String) -> T? {
        return realm?.object(ofType: type, forPrimaryKey: key)
    }
}

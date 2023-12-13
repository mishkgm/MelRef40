//
//  RootViewModel.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 27.11.2023.
//

import Foundation
import PromiseKit

protocol RootViewModelDelegate: AnyObject {
    func contentReady()
}

final class RootViewModel {
    
    weak var delegate: RootViewModelDelegate?
    
    private let dropBox = DropBoxClient.shared
    
    init(delegate: RootViewModelDelegate? = nil) {
        self.delegate = delegate
    }
    
    public func start() {
        firstly {
            dropBox.start()
        }.then { _ in
            self.getContent()
        }.ensure {
            self.delegate?.contentReady()
        }.catch { error in
            print(error)
        }
    }
    
    private func getContent() -> Promise<Void> {
        return Promise { completion in
            let promises = [
                dropBox.getContentFor(type: .mods),
                dropBox.getContentFor(type: .category),
                dropBox.getContentFor(type: .editor),
                dropBox.getContentFor(type: .items),
                dropBox.getContentFor(type: .skins),
                dropBox.getContentFor(type: .maps)
            ]
            
            when(fulfilled: promises).done { _ in
                completion.fulfill(())
            }.catch { error in
                completion.reject(error)
            }
        }
    }
}

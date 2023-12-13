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
        return Promise { comlition in
            firstly {
                dropBox.getContentFor(type: .mods)
            }.then { _ in
                self.dropBox.getContentFor(type: .category)
            }.then { _ in
                self.dropBox.getContentFor(type: .editor)
            }.then { _ in
                self.dropBox.getContentFor(type: .items)
            }.then { _ in
                self.dropBox.getContentFor(type: .skins)
            }.done { _ in
                comlition.fulfill(())
            }.catch { error in
                comlition.reject(error)
            }
        }
    }
}

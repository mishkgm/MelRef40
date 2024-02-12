//
//  BaseViewModel.swift
//  ModesTemplate
//
//  
//

import Foundation
import RealmSwift
import UIKit
import PromiseKit

protocol BaseViewModelDelegate: AnyObject {
    func reloadData()
    func showCustomAlert(style: CompleteStyle)
    func isEmtyCollection(_ isEmty: Bool)
}

extension BaseViewModelDelegate {    
    func showCustomAlert(style: CompleteStyle) {
        CompleteView.shared.showWithBlurEffect(completeStyle: style)
    }
}

class BaseViewModel {
    
    let contentType: ContentType
    weak var delegate: BaseViewModelDelegate?
    
    let dropBox = DropBoxClient.shared
    let realm = RealmManager.shared
    let network = NetworkStatusMonitor_MWP.shared
    
    init(contentType: ContentType, delegate: BaseViewModelDelegate) {
        self.contentType = contentType
        self.delegate = delegate
        self.network.delegate = self
    }
    
    func downloadImage(imagePath: String, object: Object, imageView: UIImageView) -> Promise<Data?> {
        return Promise { complition in
            firstly {
                self.dropBox.downloadImage(imagePath: imagePath)
            }.then { urlString in
                imageView.setImage(with: urlString)
            }.done { [weak self] image in
                guard let imageData = image?.pngData() else {
                    throw ViewModelError.imageError(imagePath: imagePath)
                }
                complition.fulfill(imageData)
                self?.realm.update(object, with: ["imageData" : imageData])
            }.catch { error in
                complition.reject(error)
            }
        }
    }
    
    func getContent() -> Promise<Void> {
        return Promise { comlition in
            firstly {
                dropBox.start()
            }.then {
                self.dropBox.getContentFor(type: self.contentType)
            }.done {
                comlition.fulfill(())
            }.catch { error in
                comlition.reject(error)
            }
        }
    }
}

extension BaseViewModel: NetworkStatusMonitorDelegate_MWP {
    func statusChanged() {
        self.getContent()
    }
}

private extension BaseViewModel {
    enum ViewModelError: Error {
        case imageError(imagePath: String)
//        case checkUpdateError(type: ContentType)
//        case downloadError(type: ContentType)
//        case parseError(type: ContentType)
//        case downlaodImageError(imagePath: String)
        case someError(message: String)
        case unknownError
    }
}

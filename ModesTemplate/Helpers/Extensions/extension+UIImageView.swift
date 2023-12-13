//
//  extension+UIImageView.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 27.11.2023.
//

import Foundation
import SDWebImage
import PromiseKit
import SnapKit

extension UIImageView {
    func setImage(with urlString: String?, placeholderImage: UIImage? = nil) -> Promise<UIImage?> {
        self.showLoader()
        return Promise { [weak self] seal in
            guard let urlString = urlString, let url = URL(string: urlString) else {
                // Handle invalid URL or nil string
                seal.fulfill(nil)
                return
            }

            self?.sd_setImage(with: url, placeholderImage: placeholderImage, options: .fromLoaderOnly) { (image, error, cacheType, url) in
                self?.hideLoader()
                if let error = error {
                    // Handle error (e.g., failed to download image)
                    print("Error loading image: \(error.localizedDescription)")
                    seal.reject(error)
                } else {
                    seal.fulfill(image)
                }
            }
        }
    }
    
    private func showLoader() {
        // Implement your logic to show a loader
        // For example, you can add a UIActivityIndicatorView as a subview
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.tag = 123 // Set a tag to identify the loader later
        self.addSubview(activityIndicator)
        activityIndicator.snp.remakeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func hideLoader() {
        // Implement your logic to hide the loader
        // Find the loader view by its tag and remove it
        if let loaderView = self.viewWithTag(123) as? UIActivityIndicatorView {
            loaderView.stopAnimating()
            loaderView.removeFromSuperview()
        }
    }
}

extension UIImage {
  static func resizedImage(named: String, size: CGSize) -> UIImage? {
    guard let image = UIImage(named: named) else { return nil }
    return image.resizedImage(targetSize: size)
  }
  func resizedImage(targetSize: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(targetSize, false, UIScreen.main.scale)
    self.draw(in: CGRect(origin: .zero, size: targetSize))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return resizedImage
  }
  func resizeImageTo(size: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    self.draw(in: CGRect(origin: CGPoint.zero, size: size))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return resizedImage
  }
}

//
//  EditorColletionViewCell.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 30.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class EditorColletionViewCell: BaseCollectionViewCell {
    
    lazy var imageView: UIImageView = {
       var image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    override func configureView() {
        super.configureView()
        addSubview(imageView)
    }
    
    override func makeConstraints() {
        imageView.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    func configureCell(model: EditorContentModel) {
        if let data = model.imageData {
            self.imageView.image = UIImage(data: data)
        }
    }
}

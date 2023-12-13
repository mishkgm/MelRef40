//
//  BaseCollectionViewCell.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 23.11.2023.
//

import Foundation
import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    static func cellIdentifier() -> String {
        return String(describing: self)
    }
    
    var isFavourite: Bool = false
    var favouriteComplition: ((Int) -> Void)?
    var saveComlition: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    func configureView() {
        self.backgroundColor = AppConfig.Colors.cellBackgroundColor
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1.5
        self.layer.borderColor = AppConfig.Colors.cellBorderColor.cgColor
    }
    
    func makeConstraints() {
        
    }
}

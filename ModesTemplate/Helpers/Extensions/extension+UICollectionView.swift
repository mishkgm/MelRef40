//
//  extension+UICollectionView.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 27.11.2023.
//

import Foundation
import UIKit

extension UICollectionView {
    func register(_ cell: BaseCollectionViewCell.Type) {
        self.register(cell, forCellWithReuseIdentifier: cell.cellIdentifier())
    }
}

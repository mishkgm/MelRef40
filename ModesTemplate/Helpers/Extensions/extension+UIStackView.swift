//
//  extension+UIStackView.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 06.12.2023.
//

import Foundation
import UIKit

extension UIStackView {
    func addSubviews(view: [UIView]) {
        view.forEach({ self.addArrangedSubview($0) })
    }
}

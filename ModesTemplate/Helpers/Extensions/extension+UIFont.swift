//
//  extension+UIFont.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 27.11.2023.
//

import Foundation
import UIKit

extension UIFont {
    enum FontType: String {
        case regular = "Inter-Regular"
        case semiBold = "Inter-SemiBold"
        case bold = "Inter-Bold"
        case medium = "Inter-Medium"
        case sarpanch = "Sarpanch-Medium"
    }
    
    convenience init?(size: CGFloat, type: FontType = .regular) {
        self.init(name: type.rawValue, size: isPad ? size * 1.8 : size)
    }
}

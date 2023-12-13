//
//  extension+UIButton.swift
//  ModesTemplate
//
//  Created by evhn on 29.11.2023.
//

import UIKit


extension UIButton {
    
    convenience init(localizedStringKey: String,foregroundColor: UIColor,backgroundColor: UIColor, font: UIFont) {
        self.init(type: .custom)
        setAttributedTitle(NSAttributedString(
            string: localizedString(forKey: localizedStringKey),
            attributes:[NSAttributedString.Key.font: font]), for: .normal)
        var config = UIButton.Configuration.bordered()
        config.baseForegroundColor = foregroundColor
        config.baseBackgroundColor = backgroundColor
        configuration = config
    }
    
    func onTap(perform action: @escaping () -> Void) {
        addAction(UIAction { _ in action()}, for: .touchUpInside)
    }
}

class CustomButton: UIButton {
    
    func setImage(_ image: UIImage?, size: CGFloat = 28) {
        let imageSi = isPad ? image?.resizeImageTo(size: CGSize(width: size, height: size)) : image
        self.setImage(imageSi, for: .normal)
    }
}

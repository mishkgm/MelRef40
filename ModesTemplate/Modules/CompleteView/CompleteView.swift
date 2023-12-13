//
//  CompleteView.swift
//  ModesTemplate
//
//  Created by evhn on 29.11.2023.
//

import Foundation
import UIKit

enum CompleteStyle {
    case downloaded
    case saved
    case error
    
    var localized: String {
        switch self {
        case .downloaded:
            return localizedString(forKey: "complete-downloaded")
        case .saved:
            return localizedString(forKey: "complete-saved")
        case .error:
            return "Error😥"
        }
    }
}

class CompleteView {
    static let shared = CompleteView()
    
    
    private var container = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
    private var blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private var completeTextLabel = UILabel(frame: CGRect(x: screenSize.width / 2 - (screenSize.width - 160) / 2,
                                                          y: screenSize.height / 2 - screenSize.height / 10,
                                                          width: screenSize.width - 160, height: 50))

    init() {
        completeTextLabel.backgroundColor = #colorLiteral(red: 0.2714084983, green: 0.4273136854, blue: 0.3375319242, alpha: 1)
        completeTextLabel.font = UIFont(size: 20, type: .regular)
        completeTextLabel.layer.masksToBounds = true
        completeTextLabel.layer.cornerRadius = 12
        completeTextLabel.layer.borderWidth = 1.5
        completeTextLabel.layer.borderColor = UIColor(hex: "#FAFEFB").withAlphaComponent(0.5).cgColor
        completeTextLabel.textAlignment = .center
        completeTextLabel.textColor = AppConfig.Colors.titlesColor
        container.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        blurEffect.alpha = 0
        blurEffect.frame = container.bounds
        blurEffect.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    }
    private func setupText(text: CompleteStyle) {
        completeTextLabel.text = text.localized
    }

    func showWithBlurEffect(completeStyle: CompleteStyle) {
        setupText(text: completeStyle)
        container.frame = CGRect.init(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        if !UIAccessibility.isReduceTransparencyEnabled {
            container.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            container.addSubview(blurEffect)
            container.addSubview(completeTextLabel)
        } else {
            container.backgroundColor = UIColor.white.withAlphaComponent(0.98)
        }
        if let window = getKeyWindow() {
            window.addSubview(container)
        }
        container.alpha = 0.0
        UIView.animate(withDuration: 0.1, animations: {
            self.container.alpha = 1.0
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.hide()
        }
    }
    
    private func show() -> Void {
        container.frame = CGRect.init(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        container.backgroundColor = UIColor.black.withAlphaComponent(0.80)
        if let window = getKeyWindow() {
            window.addSubview(container)
        }
        container.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            self.container.alpha = 1.0
        })
    }
    
    private func hide() {
        UIView.animate(withDuration: 0.8, animations: {
            self.container.alpha = 0.0
        }) { finished in
            self.completeTextLabel.removeFromSuperview()
            self.blurEffect.removeFromSuperview()
            self.container.removeFromSuperview()
        }
    }
    
    private func getKeyWindow() -> UIWindow? {
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        return window
    }
}

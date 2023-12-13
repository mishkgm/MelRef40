//
//  DetailButton.swift
//  ModesTemplate
//
//  Created by evhn on 29.11.2023.
//

import UIKit
import SnapKit

final class DetailButton: UIControl {
    private let buttonImageView = UIImageView()
    let buttonTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDetailButtonUI()
        setupDetailButtonCons()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setLocalizedTitle(key string: String) {
        buttonTitle.text = localizedString(forKey: string)
    }
    
    public func setButtonIcon(image: UIImage?) {
        buttonImageView.image = image
    }
    public func setBackgroundColor(color: UIColor) {
        backgroundColor = color
    }
    
    public func setForegroundColor(color: UIColor) {
        buttonTitle.textColor = color
    }
    
    public func setTitleFont(font: UIFont?) {
        buttonTitle.font = font
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.layer.opacity = 0.6
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.layer.opacity = 1
    }
    
}
// MARK: -  Setup ui
private extension DetailButton {
    func setupDetailButtonUI() {
        setupDetailButtonOS()
        addSubview(buttonImageView)
        addSubview(buttonTitle)
        setupDetailButtonCons()
        buttonImageView.tintColor = .white
    }
    
    func setupDetailButtonCons() {
        buttonImageView.snp.remakeConstraints {
            $0.leading.equalTo(self).offset(12)
            $0.centerY.equalTo(self)
            $0.size.equalTo(CGSize(width: 24, height: 24))
        }
        buttonTitle.snp.remakeConstraints {
            $0.leading.equalTo(buttonImageView.snp.trailing).offset(12)
            $0.centerY.equalTo(self)
            $0.trailing.equalTo(self).inset(12)
            
        }
    }
    
    func setupDetailButtonOS() {
        
    }
}

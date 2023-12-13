//
//  SliderViewCell.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 04.12.2023.
//

import Foundation
import UIKit
import SnapKit

final class SliderViewCell<model: EditorCellModel>: EditorCell {
    
    lazy var conteinerStack: UIStackView = {
       var stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.backgroundColor = .clear
        stack.distribution = .equalSpacing
        stack.backgroundColor = AppConfig.Colors.deteilModsbuttonBackground
        stack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    lazy var buttonStack: UIStackView = {
       var stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var loadButton: UIButton = {
       var button = UIButton()
        button.setTitle("Load", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(size: 16)
        button.backgroundColor = UIColor(hex: "#F0D045")
        return button
    }()
    
    lazy var valueLabel: UILabel = {
       var label = UILabel()
        label.textColor = .white
        label.font = UIFont(size: 40)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        label.numberOfLines = 2
        return label
    }()
    
    lazy var slider: UISlider = {
       var slider = UISlider()
        slider.setThumbImage(UIImage(), for: .normal)
        slider.minimumTrackTintColor = UIColor(hex: "#F0D045")
        slider.maximumTrackTintColor = .white
        slider.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        return slider
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.conteinerStack.setGradientBorder(width: 1, colors: [AppConfig.Colors.cellBorderColor, UIColor(hex: "#42535A")])
        }
    }
    
    override func configureView() {
        super.configureView()
        contentView.addSubview(conteinerStack)
        conteinerStack.addArrangedSubview(buttonStack)
        conteinerStack.addArrangedSubview(slider)
        buttonStack.addArrangedSubview(loadButton)
        buttonStack.addArrangedSubview(valueLabel)
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        loadButton.addTarget(self, action: #selector(loadIcon), for: .touchUpInside)
    }
    
    override func makeConstraints() {
        conteinerStack.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.leading.equalToSuperview().inset(20)
        }
    }
    
    override func configure(object: RealmEditorDeteilModel) {
        let floatValue = (Float(object.pixelValue) ?? 0.0) / 1000
        let title = model.types(for: .slider).first?.displayName ?? ""
        let fullString = title + "\n\(object.pixelValue)px"
        let attributedString = NSMutableAttributedString(string: fullString)

        // Настраиваем атрибуты для части строки
        let range = (fullString as NSString).range(of: "\(object.pixelValue)px")
        attributedString.addAttribute(.font, value: UIFont(size: 25)!, range: range)
        slider.setValue(floatValue, animated: false)
        
        valueLabel.attributedText = attributedString
//        title + "\n\(object.pixelValue)px"
        
    }
    
    @objc func sliderValueChanged(_ slider: UISlider) {
        let title = model.types(for: .slider).first?.displayName ?? ""
        let fullString = title + "\n\(slider.value * 1000)px"
        let attributedString = NSMutableAttributedString(string: fullString)

        // Настраиваем атрибуты для части строки
        let range = (fullString as NSString).range(of: "\(slider.value * 1000)px")
        attributedString.addAttribute(.font, value: UIFont(size: 25)!, range: range)
        
        valueLabel.attributedText = attributedString
        self.updateData(data: String(slider.value * 1000), type: .pixelValue)
    }
    
    @objc func loadIcon() {
        self.openImagePicker?()
    }
}

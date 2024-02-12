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
    
    lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.text = "Set file settings:"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(size: 18, type: .medium)
        return label
    }()
    
    lazy var conteinerView: UIView = {
       var view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 0.5
        view.layer.borderColor = AppConfig.Colors.cellBorderColor.cgColor
        view.backgroundColor = #colorLiteral(red: 0.2714084983, green: 0.4273136854, blue: 0.3375319242, alpha: 1)
        return view
    }()
    
    lazy var conteinerStack: UIStackView = {
       var stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.backgroundColor = .clear
        stack.distribution = .equalSpacing
        return stack
    }()
    
    lazy var buttonStack: UIStackView = {
       var stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var valueLabel: UILabel = {
       var label = UILabel()
        label.textColor = .white
        label.font = UIFont(size: 18)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        label.numberOfLines = 2
        return label
    }()
    
    lazy var pixelLabel: UILabel = {
       var label = UILabel()
        label.text = model.types(for: .slider).first?.displayName
        label.textColor = .white
        label.font = UIFont(size: 18)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    lazy var loadButton: UIButton = {
       var button = UIButton()
        button.layer.cornerRadius = 12
        button.setTitle("Upload", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(size: 16)
        button.backgroundColor = UIColor(hex: "#EBEEEC")
        return button
    }()
    
    lazy var slider: CustomSlider = {
       var slider = CustomSlider()
        slider.layer.cornerRadius = isPad ? 15 : 9
        slider.layer.borderWidth = isPad ? 4 : 2
        slider.layer.borderColor = #colorLiteral(red: 0.4048410654, green: 0.6089814305, blue: 0.4934465885, alpha: 1).cgColor
        slider.layer.masksToBounds = true
        slider.setThumbImage(createThumbImage(), for: .normal)
        slider.minimumTrackTintColor = #colorLiteral(red: 0.2705882353, green: 0.4274509804, blue: 0.337254902, alpha: 1)
        slider.maximumTrackTintColor = #colorLiteral(red: 0.4048410654, green: 0.6089814305, blue: 0.4934465885, alpha: 1)
        slider.minimumValue = 0
        slider.maximumValue = 10000
//        slider.transform = CGAffineTransform(scaleX: 1.0, y: 4)
        return slider
    }()
    
    lazy var sliderValueLabel: UILabel = {
       var label = UILabel()
        label.textColor = .white
        label.font = UIFont(size: 12)
//        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override func configureView() {
        super.configureView()
        contentView.addSubview(conteinerView)
        conteinerView.addSubview(titleLabel)
        conteinerView.addSubview(conteinerStack)
        conteinerStack.addArrangedSubview(buttonStack)
        conteinerStack.addArrangedSubview(slider)
        conteinerStack.addArrangedSubview(loadButton)
        buttonStack.addArrangedSubview(pixelLabel)
        buttonStack.addArrangedSubview(valueLabel)
        slider.addSubview(sliderValueLabel)
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        loadButton.addTarget(self, action: #selector(loadIcon), for: .touchUpInside)
    }
    
    override func makeConstraints() {
        conteinerView.snp.remakeConstraints { make in
            make.bottom.top.equalToSuperview().inset(12)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        titleLabel.snp.remakeConstraints { make in
            make.top.trailing.leading.equalToSuperview().inset(12)
        }
        sliderValueLabel.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(isPad ? 20 : 10)
        }
        conteinerStack.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.bottom.trailing.leading.equalToSuperview().inset(12)
        }
        loadButton.snp.remakeConstraints { make in
            make.height.equalTo(isPad ? 80 : 40)
        }
    }
    
    override func configure(object: RealmEditorDeteilModel) {
        let floatValue = (Float(object.pixelValue) ?? 0.0)
        slider.setValue(floatValue, animated: false)
        valueLabel.text = object.pixelValue + "px" //String(format: "%.0fpx",
        valueLabel.text?.removeAll(where: { $0 == "-"})
        sliderValueLabel.text = String(format: "%.0f", (Float(object.pixelValue) ?? 0.0) / 100) + "%"
//        title + "\n\(object.pixelValue)px"
        
    }
    
    @objc func sliderValueChanged(_ slider: UISlider) {
        valueLabel.text = String(format: "%.0fpx", slider.value)
        self.updateData(data: String(format: "%.0f", slider.value), type: .pixelValue)
        sliderValueLabel.text = String(format: "%.0f", (slider.value) * 0.01) + "%"
    }
    
    @objc func loadIcon() {
        self.openImagePicker?()
    }
    
    private func createThumbImage() -> UIImage {
        let thumbSize = CGSize(width: isPad ? 55 : 32, height: isPad ? 35 : 20) // Making the thumb image circular and proportional to the slider height
        UIGraphicsBeginImageContextWithOptions(thumbSize, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor(hex: "456D56").cgColor)
        // Draw the thumb circle
        context?.addEllipse(in: CGRect(origin: .zero, size: thumbSize))
        context?.drawPath(using: .fill)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

class CustomSlider: UISlider {
    
    @IBInspectable var trackHeight: CGFloat = isPad ? 35 : 20

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: trackHeight))
    }
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let defaultRect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        return CGRect(x: defaultRect.minX - (isPad ? 10 : 8), y: defaultRect.minY, width: defaultRect.width, height: defaultRect.height)
    }
}

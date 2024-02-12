//
//  MyWorksCollectionViewCell.swift
//  ModesTemplate
//
//  

import Foundation
import UIKit
import SnapKit

final class MyWorksViewCell: BaseCollectionViewCell {
    
    lazy var imageView: UIImageView = {
       var image = UIImageView()
        image.layer.cornerRadius = 12
        image.contentMode = .scaleAspectFit
        image.backgroundColor = AppConfig.Colors.imagesBackgoundColor
        return image
    }()
    
    lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.font = UIFont(size: 18, type: .regular)
        label.textColor = AppConfig.Colors.titlesColor
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    lazy var timeLabel: UILabel = {
       var label = UILabel()
        label.font = UIFont(size: 14, type: .regular)
        label.textColor = UIColor(hex: "#BCC5C9")
        label.textAlignment = .left
        label.text = "Create: 13 Oct,2023\nTime: 20:54"
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var buttonsStack: UIStackView = {
       var stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var editButton: UIButton = {
       var button = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = #colorLiteral(red: 0.1921568627, green: 0.7058823529, blue: 0.5843137255, alpha: 1)
        button.setImage(AppConfig.Icons.editIcon, for: .normal)
        return button
    }()
    
    lazy var deleteButton: UIButton = {
       var button = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.01960784314, blue: 0.01960784314, alpha: 1)
        button.setImage(AppConfig.Icons.binIcon, for: .normal)
        return button
    }()
    
    var deleteConplition: ((Int) -> Void)?
    var editComplition: ((Int) -> Void)?
    
    override func configureView() {
        super.configureView()
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(timeLabel)
        addSubview(buttonsStack)
        buttonsStack.addArrangedSubview(deleteButton)
        buttonsStack.addArrangedSubview(editButton)
        deleteButton.addTarget(self, action: #selector(deleteMod), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editMod), for: .touchUpInside)
    }
    
    override func makeConstraints() {
        imageView.snp.remakeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(12)
            make.height.equalToSuperview().multipliedBy(0.37)
        }
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        timeLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        buttonsStack.snp.remakeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.height.equalTo(isPad ? 48 : 32)
            make.trailing.leading.bottom.equalToSuperview().inset(12)
        }
    }
    
    @objc func deleteMod() {
        deleteConplition?(deleteButton.tag)
    }
    
    @objc func editMod() {
        editComplition?(editButton.tag)
    }
    
    func configureCell(title: String, imageData: Data?, createdDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM,yyyy"
        let firstPart = "Create: " + dateFormatter.string(from: createdDate)
        dateFormatter.dateFormat = "HH:mm"
        let secontPart = "\nTime: " + dateFormatter.string(from: createdDate)
        if let imageData = imageData {
            self.imageView.image = UIImage(data: imageData)
        }
        timeLabel.text = firstPart + secontPart
        titleLabel.text = title
    }
}

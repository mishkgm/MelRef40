//
//  MyWorksCollectionViewCell.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 30.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class MyWorksViewCell: BaseCollectionViewCell {
    
    lazy var imageView: UIImageView = {
       var image = UIImageView()
        image.backgroundColor = AppConfig.Colors.imagesBackgoundColor
        return image
    }()
    
    lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.font = UIFont(size: 14, type: .bold)
        label.textColor = AppConfig.Colors.titlesColor
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    lazy var timeLabel: UILabel = {
       var label = UILabel()
        label.font = UIFont(size: 14, type: .regular)
        label.textColor = UIColor(hex: "#BCC5C9")
        label.text = "Create: 13 Oct,2023\nTime: 20:54"
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var editButton: UIButton = {
       var button = UIButton()
        button.setBackgroundImage(AppConfig.Icons.editIcon, for: .normal)
        return button
    }()
    
    lazy var deleteButton: UIButton = {
       var button = UIButton()
        button.setBackgroundImage(AppConfig.Icons.binIcon, for: .normal)
        return button
    }()
    
    var deleteConplition: ((Int) -> Void)?
    var editComplition: ((Int) -> Void)?
    
    override func configureView() {
        super.configureView()
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(timeLabel)
        addSubview(editButton)
        addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteMod), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editMod), for: .touchUpInside)
    }
    
    override func makeConstraints() {
        imageView.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(16)
            make.width.equalToSuperview().multipliedBy(0.45)
        }
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(imageView.snp.leading).offset(-5)
        }
        timeLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(titleLabel.snp.trailing)
        }
        editButton.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.height.width.equalTo(isPad ? 36 : 24)
            make.bottom.equalToSuperview().offset(-16)
        }
        deleteButton.snp.remakeConstraints { make in
            make.leading.equalTo(editButton.snp.trailing).offset(24)
            make.centerY.equalTo(editButton.snp.centerY)
            make.height.width.equalTo(isPad ? 36 : 24)
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

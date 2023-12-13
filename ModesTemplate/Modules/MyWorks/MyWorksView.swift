//
//  MyWorksView.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 30.11.2023.
//

import Foundation
import UIKit
import SnapKit

class MyWorksView: BaseView {
    
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        var view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.register(MyWorksViewCell.self)
        return view
    }()
    
    lazy var noSavedStack: UIView = {
       var view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    
    lazy var noSavedModsImage: UIImageView = {
       var image = UIImageView()
        image.image = AppConfig.Icons.myWorks
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var noSaveModsLabel: UILabel = {
       var label = UILabel()
        label.font = UIFont(size: 20)
        label.text = "No saved works yet"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override func configureView() {
        super.configureView()
        addSubview(collectionView)
        addSubview(noSavedStack)
        noSavedStack.addSubview(noSavedModsImage)
        noSavedStack.addSubview(noSaveModsLabel)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(isPad ? 40 : 0)
            make.bottom.equalToSuperview()
        }
        noSavedStack.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.35)
        }
        noSavedModsImage.snp.remakeConstraints { make in
            make.top.trailing.leading.equalToSuperview().inset(20)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        noSaveModsLabel.snp.remakeConstraints { make in
            make.top.equalTo(noSavedModsImage.snp.bottom).offset(5)
            make.trailing.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
}

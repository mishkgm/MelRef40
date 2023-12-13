//
//  FavouritesView.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 27.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class FavouritesView: BaseView {
    
    lazy var selectCollection: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        var view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.register(FavouriteSelectorCell.self)
        view.layer.borderWidth = 1
        view.layer.borderColor = AppConfig.Colors.cellBorderColor.cgColor
        view.backgroundColor = AppConfig.Colors.cellBackgroundColor
        return view
    }()
    
    lazy var conteiner: UIView = {
       var view = UIView()
        return view
    }()
    
    lazy var emtyView: UILabel = {
       var label = UILabel()
        label.text = "No saved favorite yet"
        label.font = UIFont(size: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override func configureView() {
        super.configureView()
        addSubview(conteiner)
        addSubview(selectCollection)
        addSubview(emtyView)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        selectCollection.snp.remakeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(-10)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalToSuperview().multipliedBy(0.2)
            make.width.equalToSuperview().multipliedBy(0.28)
        }
        conteiner.snp.remakeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(0)
            make.bottom.trailing.leading.equalToSuperview()
        }
        emtyView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

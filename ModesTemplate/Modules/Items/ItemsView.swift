//
//  ItemsView.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 26.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class ItemsView: BaseView {
    
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        var view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.register(ItemsCollectionViewCell.self)
        view.register(SkinsCollectionViewCell.self)
        return view
    }()
    
    override func configureView() {
        super.configureView()
        addSubview(collectionView)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(0)
            make.trailing.leading.bottom.equalToSuperview()
        }
    }
}

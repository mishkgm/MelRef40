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
    
    lazy var filterList: FilterMenu = {
        var filter = FilterMenu()
        filter.isHidden = true
        return filter
    }()
    
    lazy var noFoundLabel: UILabel = {
       var label = UILabel()
        label.isHidden = true
        label.textColor = .white
        label.textAlignment = .center
        label.text = "There’s nothing here yet"
        label.font = UIFont(size: 20)
        return label
    }()
    
    override func configureView() {
        super.configureView()
        addSubview(collectionView)
        addSubview(filterList)
        addSubview(noFoundLabel)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(0)
            make.trailing.leading.bottom.equalToSuperview()
        }
        filterList.snp.remakeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(-5)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalToSuperview().multipliedBy(0.33)
        }
        noFoundLabel.snp.remakeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func filterShow() {
        self.filterList.isHidden = false
    }
    
    func filterHide() {
        self.filterList.isHidden = true
    }
}

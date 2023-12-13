//
//  EditorView.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 30.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class EditorView: BaseView {
    
    lazy var selectorView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        var view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = AppConfig.Colors.editorSelectorBackground
        view.register(EditorSelectorCell.self)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        var view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.register(EditorColletionViewCell.self)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectorView.setGradientBorder(width: 1, colors: [AppConfig.Colors.cellBorderColor, UIColor(hex: "#42535A")])
    }
    
    override func configureView() {
        super.configureView()
        addSubview(selectorView)
        addSubview(collectionView)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        selectorView.snp.remakeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(10)
            make.height.equalTo(isPad ? 130 : 65)
            make.trailing.leading.equalToSuperview().inset(isPad ? 60 : 20)
        }
        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(selectorView.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

//
//  DeteilView.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 30.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class DeteilEditorView: BaseView {
    
    lazy var selectorColletion: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        var view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(CategoriesViewCell.self)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var imageView: UIImageView = {
       var image = UIImageView()
        image.layer.cornerRadius = 12
        image.layer.borderWidth = 1.5
        image.layer.borderColor = AppConfig.Colors.cellBorderColor.cgColor
        image.backgroundColor = AppConfig.Colors.imagesBackgoundColor
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var conteinerTitle: UILabel = {
       var label = UILabel()
        label.font = UIFont(size: 16)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var tableView: UITableView = {
       var view = UITableView()
        EditorCellType.allCases.forEach { item in
            view.register(item.cell)
        }
        view.backgroundColor = .clear
        view.separatorStyle = .none
        return view
    }()
    
    override func configureView() {
        super.configureView()
        addSubview(imageView)
        addSubview(conteinerTitle)
        addSubview(tableView)
        addSubview(selectorColletion)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        selectorColletion.snp.remakeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(isPad ? 95 : 65)
        }
        imageView.snp.remakeConstraints { make in
            make.top.equalTo(selectorColletion.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(isPad ? 60 : 20)
            make.height.equalTo(isPad ? 250 : 150)
        }
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(isPad ? 40 : 0)
            make.bottom.equalToSuperview()
        }
    }
}

final class DeteilEditorTabSelector: BaseCollectionViewCell {
    
    lazy var titleLabel: UILabel = {
       var label = UILabel()
        return label
    }()
    
    override func configureView() {
        addSubview(titleLabel)
    }
    
    override func makeConstraints() {
        titleLabel.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(type: EditorViewType) {
        self.titleLabel.text = type.rawValue
    }
}

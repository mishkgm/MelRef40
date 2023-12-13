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
    
    lazy var selectorColletion: DropDownMenu = {
        var view = DropDownMenu()
        return view
    }()
    
    lazy var imageView: UIImageView = {
       var image = UIImageView()
        image.backgroundColor = UIColor(hex: "#737B89")
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectorColletion.layer.sublayers?.removeAll(where: { $0.isKind(of: CAGradientLayer.self )})
        self.selectorColletion.setGradientBorder(width: 1, colors: [AppConfig.Colors.cellBorderColor, UIColor(hex: "#42535A")])
        self.selectorColletion.layoutIfNeeded()
    }
    
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
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.trailing.leading.equalToSuperview().inset(isPad ? 60 : 20)
        }
        imageView.snp.remakeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(isPad ? 100 : 70)
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

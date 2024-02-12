//
//  MenuView.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 26.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class MenuView: BaseView {
    
    lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.text = "Menu"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(size: 24, type: .semiBold)
        return label
    }()
    
    lazy var tableView: UITableView = {
       let view = UITableView()
        view.backgroundColor = .clear
        view.register(MenuTableViewCell.self)
        view.separatorStyle = .none
        return view
    }()
    
    lazy var closeButton: UIButton = {
       var button = UIButton()
        button.setBackgroundImage(AppConfig.Icons.crossButton, for: .normal)
        return button
    }()
    
    override func configureView() {
        backgroundColor = UIColor(hex: "#2F2E34")
        addSubview(titleLabel)
        addSubview(closeButton)
        addSubview(tableView)
        bannerView.isHidden = true
    }
    
    override func makeConstraints() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(isPad ? 60 : 20)
            make.bottom.equalToSuperview()
        }
        closeButton.snp.remakeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.trailing.equalToSuperview().inset(isPad ? 60 : 20)
            make.height.width.equalTo(isPad ? 38 : 24)
        }
    }
    
}

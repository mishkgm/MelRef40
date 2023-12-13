//
//  SettingsView.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 27.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class SettingsView: BaseView {
    
    lazy var tableView: UITableView = {
       var view = UITableView()
        view.separatorColor = AppConfig.Colors.tableViewSeparatorColor
        view.backgroundColor = .clear
        view.register(SettingViewCell.self)
        return view
    }()
    
    override func configureView() {
        super.configureView()
        addSubview(tableView)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(isPad ? 60 : 20)
            make.bottom.equalToSuperview()
        }
    }
}

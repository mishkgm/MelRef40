//
//  SettingViewController.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 27.11.2023.
//

import Foundation
import UIKit

enum Setting: String, CaseIterable {
    case privacy = "Privacy Policy"
    case terms = "Terms of Use"
    
    var settingUrl: URL? {
        switch self {
        case .privacy:
            return URL(string: Configurations_MWP.policyLink)
        case .terms:
            return URL(string: Configurations_MWP.termsLink)
        }
    }
    var icon: UIImage? {
        switch self {
        case .privacy:
            return AppConfig.Icons.privacyPolicyicon
        case .terms:
            return AppConfig.Icons.termsOfUse

        }
    }
}

final class SettingsViewController: BaseViewController {
    
    lazy var mainView: SettingsView = {
       var view = SettingsView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.bannerView.subDelegate = self
        return view
    }()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Setting.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewCell.cellIdentifier(), for: indexPath) as? SettingViewCell else { return UITableViewCell() }
        cell.configureCell(setting: Setting.allCases[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = Setting.allCases[indexPath.row].settingUrl else { return }
        UIApplication.shared.open(url)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isPad ? 112 : 72
    }
}

//
//  extension+UITableView.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 26.11.2023.
//

import Foundation
import UIKit

let screenSize = UIScreen.main.bounds
let isPad = UIDevice.current.userInterfaceIdiom == .pad

extension UITableView {
    func register(_ cell: BaseTableViewCell.Type) {
        self.register(cell, forCellReuseIdentifier: cell.cellIdentifier())
    }
}

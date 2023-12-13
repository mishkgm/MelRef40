//
//  MenuViewController.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 26.11.2023.
//

import Foundation
import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    func didSelectIndex(_ index: Int)
}

final class MenuViewController: UIViewController {
    
    lazy var mainView: MenuView = {
       var view = MenuView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        return view
    }()
    
    weak var delegate: MenuViewControllerDelegate?
    private var currentIndex: Int
    
    init(delegate: MenuViewControllerDelegate?, currentIndex: Int) {
        self.delegate = delegate
        self.currentIndex = currentIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ControllersType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.cellIdentifier(), for: indexPath) as? MenuTableViewCell else { return UITableViewCell() }
        cell.configureCell(for: ControllersType.allCases[indexPath.row], isSelected: indexPath.row == currentIndex)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.currentIndex != indexPath.row else {
            self.dismiss(animated: true)
            return
        }
        self.delegate?.didSelectIndex(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(ControllersType.allCases.count)
    }
}

//
//  MyWorksViewController.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 30.11.2023.
//

import Foundation
import UIKit

final class MyWorksViewController: BaseViewController {
    
    lazy var mainView: MyWorksView = {
       var view = MyWorksView()
        view.collectionView.delegate = self
        view.collectionView.dataSource = self
        return view
    }()
    
    lazy var viewModel: MyWorksViewModel = {
       var model = MyWorksViewModel()
        model.delegate = self
        return model
    }()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.feathcData()
    }
}

extension MyWorksViewController: MyWorksViewModelDelegate {
    func reloadData() {
        self.mainView.collectionView.isHidden = viewModel.model.isEmpty
        self.mainView.noSavedStack.isHidden = !viewModel.model.isEmpty
        self.mainView.collectionView.reloadData()
    }
}

extension MyWorksViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyWorksViewCell.cellIdentifier(), for: indexPath) as? MyWorksViewCell else { return UICollectionViewCell() }
        cell.configureCell(title: viewModel.model[indexPath.row].name, imageData: viewModel.model[indexPath.row].iconData, createdDate: viewModel.model[indexPath.row].createdDate)
        cell.deleteButton.tag = indexPath.row
        cell.editButton.tag = indexPath.row
        cell.deleteConplition = { [weak self] index in
            self?.showDeleteAlert(index: index)
        }
        cell.editComplition = { [weak self] index in
            self?.showDetailEditor(index: index)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return isPad ? CGSize(width: screenSize.width/3 - 45, height: screenSize.height / 4) :
        CGSize(width: screenSize.width / 2 - 25, height: screenSize.height / 3.3)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
}

private extension MyWorksViewController {
    func showDeleteAlert(index: Int) {
        let alert = CustomAlertViewController(alertStyle: .myWorksDelete(modName: viewModel.model[index].name))
        alert.customAlertView.deleteButton.setTitle("Delete", for: .normal)
        alert.modalPresentationStyle = .overCurrentContext
        alert.deleteHandler = { [weak self] in
            self?.viewModel.deleteMod(index: index)
        }
        self.present(alert, animated: true)
    }
    
    func showDetailEditor(index: Int) {
        flowDelegate?.showDeteilEditor(objct: viewModel.model[index], title: "My work")
    }
}

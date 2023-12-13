//
//  EditorViewController.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 30.11.2023.
//

import Foundation
import UIKit

enum EditorContentType: String, CaseIterable {
    case miscTemplate = "Misc templates"
    case living = "Living templates"
    
    var image: UIImage? {
        switch self {
        case .miscTemplate:
            return AppConfig.Icons.editorMisc
        case .living:
            return AppConfig.Icons.editorLiving
        }
    }
}

final class EditorViewController: BaseViewController {
    
    lazy var mainView: EditorView = {
       var view = EditorView()
        view.collectionView.delegate = self
        view.collectionView.dataSource = self
        view.selectorView.dataSource = self
        view.selectorView.delegate = self
        view.bannerView.subDelegate = self
        return view
    }()
    
    lazy var viewModel: EditorViewModel = {
        var model = EditorViewModel(contentType: .editor, delegate: self)
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
        viewModel.updateContent()
    }
}

extension EditorViewController: BaseViewModelDelegate {
    func isEmtyCollection(_ isEmty: Bool) {
        
    }
    
    func reloadData() {
        guard !viewModel.getCurrentModel().isEmpty else { return }
        self.mainView.collectionView.reloadData()
        self.mainView.selectorView.reloadData()
        self.mainView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
    }
}

extension EditorViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView == mainView.collectionView {
        case true: return viewModel.getCurrentModel().count
        case false: return EditorContentType.allCases.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView == mainView.collectionView {
        case true:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditorColletionViewCell.cellIdentifier(), for: indexPath) as? EditorColletionViewCell else { return UICollectionViewCell() }
            cell.configureCell(model: viewModel.getCurrentModel()[indexPath.row])
            viewModel.downloadImage(key: viewModel.getCurrentModel()[indexPath.row].realmKey, imageView: cell.imageView)
            return cell
        case false:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditorSelectorCell.cellIdentifier(), for: indexPath) as? EditorSelectorCell else { return UICollectionViewCell() }
            cell.configureCell(type: EditorContentType.allCases[indexPath.row], isSelected: viewModel.currentSelectedType == EditorContentType.allCases[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView == mainView.collectionView {
        case true:
            guard let imageData = self.viewModel.getCurrentModel()[indexPath.row].imageData else { return }
            flowDelegate?.showDeteilEditor(imageData: imageData, title: "name")
        case false:
            viewModel.selectContentType(type: EditorContentType.allCases[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView == mainView.collectionView {
        case true:
            return isPad ? CGSize(width: collectionView.frame.width - 120, height: collectionView.frame.height / 3.8) : CGSize(width: collectionView.frame.width - 40, height: collectionView.frame.height / 3.8)
        case false:
            return isPad ? CGSize(width: collectionView.frame.width/2 - 10, height:  collectionView.frame.height - 10) : CGSize(width: collectionView.frame.width/2 - 10, height: collectionView.frame.height - 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView == mainView.collectionView {
        case true:
            return isPad ? UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 60) : UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
        case false:
            return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        }
    }
}

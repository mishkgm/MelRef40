//
//  DropDownMenu.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 06.12.2023.
//

import Foundation
import UIKit
import SnapKit

protocol DropDownMenuDelegate: UIViewController {
    func cellDidTap(index: Int)
}

final class DropDownMenu: UIView {
    
    lazy var chevronImageView: UIImageView = {
       var image = UIImageView()
        image.contentMode = .scaleToFill
        image.image = AppConfig.Icons.categoryChevron
        return image
    }()
    
    lazy var categoryCollection: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.distribution = .fillEqually
        view.axis = .vertical
        return view
    }()
    
    weak var delegate: DropDownMenuDelegate?
    private var items: [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(categoryCollection)
        categoryCollection.addSubview(chevronImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.categoryCollection.layoutSubviews()
        categoryCollection.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        chevronImageView.snp.remakeConstraints { make in
            make.centerY.equalTo(self.categoryCollection.subviews.first?.snp.centerY ?? 0)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(isPad ? 36 : 24)
        }
    }
    
    public func openСategoryPicker(items: [String]) {
        self.items = items
        categoryCollection.subviews.forEach { view in
            if view.isMember(of: CategoriesViewCell.self) {
                view.removeFromSuperview()
            }
        }
        for (index, model) in items.enumerated() {
            let isLocked: Bool = index == 1 && !IAPManager_MWP.shared.productBought.contains(.unlockContentProduct)
//            let cell = CategoriesViewCell(item: model, isLocked: isLocked)
            let cell = UIView()
            cell.tag = index
            addTapGesture(view: cell)
            categoryCollection.addArrangedSubview(cell)
        }
        categoryCollection.bringSubviewToFront(chevronImageView)
        UIView.animate(withDuration: 0.2) {
            self.chevronImageView.transform = CGAffineTransform(rotationAngle: .pi)
        }
        self.layoutSubviews()
    }
    
    public func closeCategoryPicker(currentItem: String) {
        categoryCollection.subviews.forEach { view in
            if view.isMember(of: CategoriesViewCell.self) {
                view.removeFromSuperview()
            }
        }
        categoryCollection.addArrangedSubview(UIView())
        categoryCollection.bringSubviewToFront(chevronImageView)
        UIView.animate(withDuration: 0.2) {
            self.chevronImageView.transform = CGAffineTransform.identity
        }
        self.layoutSubviews()
    }
}

private extension DropDownMenu {
    @objc func cellTapped(_ sender: UITapGestureRecognizer) {
        self.delegate?.cellDidTap(index: sender.view?.tag ?? 0)
    }
    
    func addTapGesture(view: UIView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        view.addGestureRecognizer(gesture)
    }
}

//
//  DropDownFilter.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 28.12.2023.
//

import Foundation
import UIKit
import SnapKit

final class FilterMenu: UIView {

    lazy var categoryCollection: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.axis = .vertical
        view.backgroundColor = AppConfig.Colors.cellBackgroundColor
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1.5
        view.layer.borderColor = AppConfig.Colors.cellBorderColor.cgColor
        view.isUserInteractionEnabled = true
        return view
    }()
    
    weak var delegate: DropDownMenuDelegate?
    var items: [String] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(categoryCollection)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        categoryCollection.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func openСategoryPicker(items: [String], isCurrent: String = "") {
        self.items = items
        categoryCollection.subviews.forEach { view in
            if view.isMember(of: DropDownCell.self) {
                view.removeFromSuperview()
            }
        }
        for (index, model) in items.enumerated() {
            let cell = DropDownCell(title: model, isCentrallSetup: true, isSelected: isCurrent == model)
            cell.tag = index
            addTapGesture(view: cell)
            categoryCollection.addArrangedSubview(cell)
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
        self.layoutSubviews()
    }
}

private extension FilterMenu {
    @objc func cellTapped(_ sender: UITapGestureRecognizer) {
        self.delegate?.cellDidTap(text: items[sender.view?.tag ?? 0])
    }
    
    func addTapGesture(view: UIView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        view.addGestureRecognizer(gesture)
    }
}

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
    func cellDidTap(text: String?)
}

final class DropDownMenu: UIView {
    
    lazy var scrollView: UIScrollView = {
       var view = UIScrollView()
        view.backgroundColor = AppConfig.Colors.cellBackgroundColor
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1.5
        view.layer.borderColor = AppConfig.Colors.cellBorderColor.cgColor
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var chevronImageView: UIImageView = {
       var image = UIImageView()
        image.contentMode = .scaleToFill
        image.image = AppConfig.Icons.categoryChevron
        image.isHidden = true
        return image
    }()
    
    lazy var categoryCollection: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.axis = .vertical
        view.isUserInteractionEnabled = true
        return view
    }()
    
    var isCentrallSetup: Bool
    weak var delegate: DropDownMenuDelegate?
    var items: [String] = []
    
    init(isCentrallSetup: Bool) {
        self.isCentrallSetup = isCentrallSetup
        super.init(frame: .zero)
        addSubview(scrollView)
        scrollView.addSubview(categoryCollection)
        categoryCollection.addSubview(chevronImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.layoutSubviews()
        var coof = 0
        if items.count <= 4 {
            coof = items.count
        } else {
            coof = 4
        }
        scrollView.snp.remakeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.height.lessThanOrEqualTo(isPad ? 70 * coof : 48 * coof)
            make.height.greaterThanOrEqualTo(0)
        }
        categoryCollection.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        chevronImageView.snp.remakeConstraints { make in
            make.centerY.equalTo(self.categoryCollection.subviews.first?.snp.centerY ?? 0)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(isPad ? 36 : 24)
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
            let cell = DropDownCell(title: model, isCentrallSetup: isCentrallSetup, isSelected: isCurrent == model)
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
        self.delegate?.cellDidTap(text: items[sender.view?.tag ?? 0])
    }
    
    func addTapGesture(view: UIView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        view.addGestureRecognizer(gesture)
    }
}

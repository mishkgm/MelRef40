//
//  DropDownCell.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 15.12.2023.
//

import Foundation
import UIKit
import SnapKit

final class DropDownCell: BaseView {
    lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.textColor = .white
        label.font = UIFont(size: 18, type: .medium)
        return label
    }()
    
    lazy var separatorView: UIView = {
       var view = UIView()
        view.backgroundColor = UIColor(hex: "#FAFEFB").withAlphaComponent(0.2)
        return view
    }()
    
    private var isCentall: Bool = false
    
    init(title: String, isCentrallSetup: Bool, isSelected: Bool) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.isCentall = isCentrallSetup
        self.titleLabel.textAlignment = isCentrallSetup ? .center : .left
        self.titleLabel.textColor = isSelected ? .white : UIColor(hex: "#FAFEFB").withAlphaComponent(0.6)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        addSubview(titleLabel)
        addSubview(separatorView)
    }
    
    override func makeConstraints() {
        self.snp.remakeConstraints { make in
            make.height.equalTo(isPad ? 70 : 48)
        }
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(12)
            if isCentall {
                make.leading.equalToSuperview().inset(44)
                make.trailing.equalToSuperview().inset(5)
            } else {
                make.leading.trailing.equalToSuperview().inset(10)
            }
            
            make.bottom.equalToSuperview().inset(12)
        }
        separatorView.snp.remakeConstraints { make in
            make.height.equalTo(1)
            if isCentall {
                make.leading.equalToSuperview().inset(44)
                make.leading.equalToSuperview().inset(5)
            } else {
                make.leading.trailing.equalToSuperview().inset(10)
            }
            make.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview()
        }
    }
}

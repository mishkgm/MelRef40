//
//  DeteilStackView.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 04.12.2023.
//

import Foundation
import UIKit
import SnapKit

class DeteilStackView: UIView {
    
    public var spacing: CGFloat = 0
    
    private(set) var columnViews: [UIView] = []
    private let maxColumns = 2
    private var currentRow: UIStackView?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addView(_ view: UIView) {
        if currentRow == nil || columnViews.count % maxColumns == 0 {
            createNewRow()
        }
        currentRow?.addArrangedSubview(view)
        columnViews.append(view)
    }

    private func createNewRow() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.snp.remakeConstraints { make in
            make.top.equalTo(currentRow?.snp.bottom ?? snp.top).offset(spacing)
            make.trailing.leading.equalToSuperview()
        }
        currentRow = stackView
    }
}

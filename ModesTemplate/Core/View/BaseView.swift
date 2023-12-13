//
//  BaseView.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 23.11.2023.
//

import UIKit
import SnapKit

class BaseView: UIView {
    
    lazy var backgroundImage: UIImageView = {
       var image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = AppConfig.Icons.background
        return image
    }()
    
    lazy var bannerView: BannerView = {
       var view = BannerView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    func configureView() {
        addSubview(backgroundImage)
        addSubview(bannerView)
    }
    
    func makeConstraints() {
        backgroundImage.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        bannerView.snp.remakeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.trailing.leading.equalToSuperview().inset(isPad ? 60 : 20)
            make.height.equalTo((bannerView.isHidden ? 0 : 0.20) * screenSize.height)
        }
    }
}

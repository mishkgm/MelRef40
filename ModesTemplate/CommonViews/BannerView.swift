//
//  BannerView.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 03.12.2023.
//

import Foundation
import UIKit

enum BannerState {
    case first
    case second
    case third
    case none
    
    var image: UIImage? {
        switch self {
        case .first:
            return AppConfig.Icons.bannerFirstImage
        case .second:
            return AppConfig.Icons.bannerSecondImage
        case .third:
            return AppConfig.Icons.thirdBannerImage
        case .none:
            return nil
        }
    }
    
    var productType: PremiumMainController_MWPStyle {
        switch self {
        case .first:
            return .unlockFuncProduct
        case .second:
            return .unlockContentProduct
        case .third:
            return .unlockOther
        case .none:
            return .mainProduct
        }
    }
}

protocol BannerViewDelegate: AnyObject {
    func openSub(style: PremiumMainController_MWPStyle)
}

final class BannerView: UIImageView {
    
    weak var subDelegate: BannerViewDelegate?
    private var currentState: BannerState = .first
    
    init(subDelegate: BannerViewDelegate? = nil) {
        super.init(frame: .zero)
        self.subDelegate = subDelegate
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        currentState = getState()
        self.image = currentState.image
        self.isHidden = currentState == .none
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openSub))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func openSub() {
        self.subDelegate?.openSub(style: currentState.productType)
    }
    
    func getState() -> BannerState {
        if !IAPManager_MWP.shared.productBought.contains(.unlockFuncProduct) {
            return .first
        } else if !IAPManager_MWP.shared.productBought.contains(.unlockContentProduct) {
            return .second
        } else if !IAPManager_MWP.shared.productBought.contains(.unlockOther) {
            return .third
        } else {
            return .none
        }
    }
}

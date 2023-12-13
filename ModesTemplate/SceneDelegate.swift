//
//  SceneDelegate.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 23.11.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: MainFlowCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        UIView.appearance().isMultipleTouchEnabled = false
        UIView.appearance().isExclusiveTouch = true
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.overrideUserInterfaceStyle = .light
        self.coordinator = MainFlowCoordinator()
        IAPManager_MWP.shared.validateSubscriptions_MWP(productIdentifiers: [Configurations_MWP.mainSubscriptionID, Configurations_MWP.unlockFuncSubscriptionID, Configurations_MWP.unlockContentSubscriptionID, Configurations_MWP.unlockerThreeSubscriptionID]) { prod in
            if prod[Configurations_MWP.mainSubscriptionID] ?? false {
                let controller = self.coordinator?.launchViewController()
                self.window?.rootViewController = controller
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    let controller = self.coordinator?.launchSub()
                    self.window?.rootViewController = controller
                }
            }
        }
        self.window?.makeKeyAndVisible()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            ThirdPartyServicesManager_MWP.shared.makeATT_MWP()
        }
    }
}


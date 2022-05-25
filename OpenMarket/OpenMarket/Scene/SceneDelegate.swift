//
//  OpenMarket - SceneDelegate.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        if #available(iOS 14.0, *) {
            window.rootViewController = UINavigationController(rootViewController: MainViewController())
        } else {
            window.rootViewController = UINavigationController(rootViewController: MainViewControllerUnderiOS14())
        }
        window.makeKeyAndVisible()
        self.window = window
    }
}

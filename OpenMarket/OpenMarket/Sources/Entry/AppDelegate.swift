//
//  OpenMarket - AppDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()

        let rootViewController = UINavigationController(rootViewController: MarketItemsViewController())
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

        return true
    }
}


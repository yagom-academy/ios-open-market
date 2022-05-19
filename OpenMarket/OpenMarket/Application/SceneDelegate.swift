//
//  SceneDelegate.swift
//  Created by Lingo, Quokka
// 

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    self.window = UIWindow(windowScene: windowScene)
    let rootViewController = ProductListViewController()
    self.window?.rootViewController = UINavigationController(
      rootViewController: rootViewController)
    self.window?.makeKeyAndVisible()
  }
}

//
//  SKBTransactionViewerApp.swift
//  SKBTransactionViewer
//
//  Created by Dmitry Mikhailov on 23.10.2024.
//

import SwiftUI
import UIKit

// MARK: - SwiftUI

@main
struct SKBTransactionViewerApp: App {
  // TODO: Add dependency injection
  let repository = PlistTransactionsRepository()
  var body: some Scene {
    WindowGroup {
      let coordinator = AppCoordinator(repository: repository)
      coordinator.start()
    }
  }
}

// MARK: - AppDelegate

class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var appCoordinator: AppCoordinator?

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let navigationController = UINavigationController()
    appCoordinator = AppCoordinator(
      navigationController: navigationController,
      repository: PlistTransactionsRepository()
    )
    appCoordinator?.start()

    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()

    return true
  }
}

//
//  SceneDelegate.swift
//  Aura
//
//  Created by Anton Solovev on 01.04.2025.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        let dependencies = AppDependencies.production()
        
        appCoordinator = AppCoordinator(navigationController: navigationController, dependencies: dependencies)
        appCoordinator?.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        CoreDataManager.shared.saveContext()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        appCoordinator?.handleAppDidBecomeActive()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {}
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataManager.shared.saveContext()
    }
}


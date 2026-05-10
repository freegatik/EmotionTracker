//
//  WelcomeCoordinator.swift
//  Aura
//
//  Created by Anton Solovev on 08.04.2025.
//

import UIKit
import WebKit

final class WelcomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    private let dependencies: AppDependencies
    
    init(navigationController: UINavigationController, dependencies: AppDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        if ProcessInfo.processInfo.arguments.contains("UITEST_SKIP_WELCOME") {
            showTabBar()
            return
        }

        let welcomeViewController = WelcomeViewController()
        welcomeViewController.coordinator = self
        navigationController.setViewControllers([welcomeViewController], animated: false)
    }
    
    func handleAppleIDAuthentication() {
        let webViewController = UIViewController()
        let webView = WKWebView(frame: webViewController.view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webViewController.view.addSubview(webView)
        
        if let url = URL(string: "https://appleid.apple.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        navigationController.present(webViewController, animated: true)
        
        let workItem = DispatchWorkItem { [weak self] in
            webViewController.dismiss(animated: true) {
                let userID = "test.user.id"
                let email = "test@example.com"
                
                UserDefaults.standard.set(userID, forKey: "appleUserID")
                UserDefaults.standard.set(email, forKey: "appleUserEmail")
                
                self?.showTabBar()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: workItem)
    }
    
    private func showTabBar() {
        let tabBarCoordinator = TabBarCoordinator(
            navigationController: navigationController,
            dependencies: dependencies
        )
        childCoordinators.append(tabBarCoordinator)
        finish()
        tabBarCoordinator.start()
    }
}

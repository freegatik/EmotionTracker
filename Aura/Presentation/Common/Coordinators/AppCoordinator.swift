//
//  AppCoordinator.swift
//  Aura
//
//  Created by Anton Solovev on 07.04.2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    private let dependencies: AppDependencies
    
    init(navigationController: UINavigationController, dependencies: AppDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        if dependencies.coreDataService.isBiometricEnabled {
            showBiometricAuth()
        } else {
            showWelcome()
        }
    }
    
    private func showBiometricAuth() {
        let authVC = BiometricAuthViewController(biometricService: dependencies.biometricService) { [weak self] in
            self?.showTabBar()
        }
        
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([authVC], animated: false)
    }
    
    private func showWelcome() {
        let welcomeCoordinator = WelcomeCoordinator(
            navigationController: navigationController,
            dependencies: dependencies
        )
        childCoordinators.append(welcomeCoordinator)
        welcomeCoordinator.start()
    }
    
    private func showTabBar() {
        let tabBarCoordinator = TabBarCoordinator(
            navigationController: navigationController,
            dependencies: dependencies
        )
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
    
    func handleAppDidBecomeActive() {
        if dependencies.coreDataService.isBiometricEnabled {
            showBiometricAuth()
        }
    }
}

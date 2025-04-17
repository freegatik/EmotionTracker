//
//  SettingsCoordinator.swift
//  Aura
//
//  Created by Anton Solovev on 17.04.2025.
//

import UIKit

final class SettingsCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let settingsViewController = SettingsViewController()
        settingsViewController.coordinator = self
        navigationController.setViewControllers([settingsViewController], animated: false)
    }
}

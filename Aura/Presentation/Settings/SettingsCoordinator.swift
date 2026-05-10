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
    
    private let dependencies: AppDependencies
    
    init(navigationController: UINavigationController, dependencies: AppDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let viewModel = SettingsViewModel(
            notificationService: dependencies.notificationService,
            coreDataService: dependencies.coreDataService,
            biometricService: dependencies.biometricService
        )
        let settingsViewController = SettingsViewController(viewModel: viewModel)
        settingsViewController.coordinator = self
        navigationController.setViewControllers([settingsViewController], animated: false)
    }
}

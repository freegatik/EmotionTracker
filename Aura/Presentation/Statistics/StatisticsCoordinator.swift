//
//  StatisticsCoordinator.swift
//  Aura
//
//  Created by Anton Solovev on 13.04.2025.
//

import UIKit

final class StatisticsCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.coordinator = self
        navigationController.setViewControllers([statisticsViewController], animated: false)
    }
}

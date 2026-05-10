//
//  AppDependencies.swift
//  Aura
//
//  Created by Anton Solovev on 01.04.2025.
//

import Foundation

struct AppDependencies {
    let coreDataService: CoreDataServiceProtocol
    let biometricService: BiometricServiceProtocol
    let notificationService: NotificationServiceProtocol

    static func production() -> AppDependencies {
        let coreDataService = CoreDataService()
        return AppDependencies(
            coreDataService: coreDataService,
            biometricService: BiometricService(),
            notificationService: NotificationService.shared
        )
    }

    /// Explicit graph for tests and previews (no singletons required).
    static func testing(
        coreDataService: CoreDataServiceProtocol,
        biometricService: BiometricServiceProtocol,
        notificationService: NotificationServiceProtocol
    ) -> AppDependencies {
        AppDependencies(
            coreDataService: coreDataService,
            biometricService: biometricService,
            notificationService: notificationService
        )
    }
}

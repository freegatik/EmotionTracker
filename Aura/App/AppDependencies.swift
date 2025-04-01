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

    static func production() -> AppDependencies {
        AppDependencies(
            coreDataService: CoreDataService(),
            biometricService: BiometricService()
        )
    }
}

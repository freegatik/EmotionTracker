//
//  MockBiometricService.swift
//  AuraTests
//
//  Created by Anton Solovev on 06.05.2026.
//

import Foundation
@testable import Aura

final class MockBiometricService: BiometricServiceProtocol {
    var biometricType: BiometricType
    var nextResult: (success: Bool, error: Error?)
    var authenticateCalls: Int = 0

    init(
        biometricType: BiometricType = .faceID,
        nextResult: (success: Bool, error: Error?) = (true, nil)
    ) {
        self.biometricType = biometricType
        self.nextResult = nextResult
    }

    func authenticate(completion: @escaping (Bool, (any Error)?) -> Void) {
        authenticateCalls += 1
        completion(nextResult.success, nextResult.error)
    }
}

//
//  MockNotificationService.swift
//  AuraTests
//
//  Created by Anton Solovev on 06.05.2026.
//

import Foundation
@testable import Aura

final class MockNotificationService: NotificationServiceProtocol {
    var isAuthorized: Bool = false
    var authorizationRequestsCount: Int = 0
    var scheduledNotifications: [String] = []
    var removedNotifications: [String] = []
    var removeAllNotificationsCalls: Int = 0

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        authorizationRequestsCount += 1
        completion(isAuthorized)
    }

    func scheduleNotification(at time: Date, repeats: Bool) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        scheduledNotifications.append(formatter.string(from: time))
    }

    func removeAllNotifications() {
        removeAllNotificationsCalls += 1
        scheduledNotifications.removeAll()
    }

    func isNotificationsEnabled(completion: @escaping (Bool) -> Void) {
        completion(isAuthorized)
    }

    func removeNotification(for timeString: String) {
        removedNotifications.append(timeString)
        scheduledNotifications.removeAll { $0 == timeString }
    }
}

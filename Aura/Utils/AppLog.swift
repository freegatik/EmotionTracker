//
//  AppLog.swift
//  Aura
//
//  Created by Anton Solovev on 04.04.2025.
//

import Foundation
import os

enum AppLog {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "Aura"

    static let persistence = Logger(subsystem: subsystem, category: "Persistence")
    static let data = Logger(subsystem: subsystem, category: "Data")
}

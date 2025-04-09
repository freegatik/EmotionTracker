//
//  Coordinator.swift
//  Aura
//
//  Created by Anton Solovev on 07.04.2025.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func finish()
}

extension Coordinator {
    func finish() {
    }
}

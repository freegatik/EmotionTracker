//
//  UIViewController+Extensions.swift
//  Aura
//
//  Created by Anton Solovev on 06.04.2025.
//

import UIKit

// MARK: - Configure Navigation Bar

extension UIViewController {
    func configureNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .clear
            appearance.shadowColor = .clear
            
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.compactAppearance = appearance
            
            navigationBar.isTranslucent = true
            navigationBar.backgroundColor = .clear
            navigationBar.isHidden = true
            navigationBar.isUserInteractionEnabled = false
        }
    }
}

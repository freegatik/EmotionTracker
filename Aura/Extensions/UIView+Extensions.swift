//
//  UIView+Extensions.swift
//  Aura
//
//  Created by Anton Solovev on 06.04.2025.
//

import UIKit

extension UIView {
    func findSubview<T: UIView>(ofType type: T.Type, where predicate: (T) -> Bool) -> T? {
        for subview in subviews {
            if let typed = subview as? T, predicate(typed) {
                return typed
            }
            if let found = subview.findSubview(ofType: type, where: predicate) {
                return found
            }
        }
        return nil
    }
}

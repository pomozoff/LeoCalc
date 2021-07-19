//
//  Action+Feature.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 19.07.2021.
//

import FeatureToggleKit
import Foundation

extension Action: Feature {
    var name: String { title }

    var isEnabled: Bool {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.isEnabled) as? Bool ?? false
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.isEnabled, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

private struct AssociatedKeys {
    static var isEnabled: UInt8 = 0
}

//
//  FeatureModel.swift
//  
//
//  Created by Anton Pomozov on 15.07.2021.
//

import FeatureToggleKit
import Foundation

struct FeatureModel {
    let id: Int
    let name: String
    let enabled: Bool
    let till: Date?

    var action: Action? {
        Behavior.Kind.allCases.first { $0.rawValue == name }.map { Action(type: $0) }
    }
}

extension FeatureModel: DecodableFeature {
    var isEnabled: Bool {
        enabled && (till.map { $0 < Date() } ?? true)
    }
}

//
//  MainBuilder.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 17.07.2021.
//

import FeatureToggleKit
import Foundation

typealias FeaturesProvider = Provider<FeatureModel, Action>

class MainBuilder {
    static func buildViewModel() -> MainViewModel {
        let jsonSource = JSONSource<FeatureModel>(fileUrl: Bundle.main.url(forResource: "featuresList", withExtension: "json")!)
        let provider = FeaturesProvider(sources: [jsonSource.anySource], mapper: \.action)

        let viewModel = MainViewModel(
            provider: provider,
            buttons: [
                .init(place: .top,    action: .clear,          isEnabled: true, isVisible: true),
                .init(place: .top,    action: .sin,            isEnabled: true, isVisible: true),
                .init(place: .top,    action: .cos,            isEnabled: true, isVisible: true),
                .init(place: .static, action: .seven,          isEnabled: true, isVisible: true),
                .init(place: .static, action: .eight,          isEnabled: true, isVisible: true),
                .init(place: .static, action: .nine,           isEnabled: true, isVisible: true),
                .init(place: .static, action: .four,           isEnabled: true, isVisible: true),
                .init(place: .static, action: .five,           isEnabled: true, isVisible: true),
                .init(place: .static, action: .six,            isEnabled: true, isVisible: true),
                .init(place: .static, action: .one,            isEnabled: true, isVisible: true),
                .init(place: .static, action: .two,            isEnabled: true, isVisible: true),
                .init(place: .static, action: .three,          isEnabled: true, isVisible: true),
                .init(place: .static, action: .zero,           isEnabled: true, isVisible: true),
                .init(place: .static, action: .point,          isEnabled: true, isVisible: true),
                .init(place: .side,   action: .bitcoin,        isEnabled: true, isVisible: true),
                .init(place: .side,   action: .division,       isEnabled: true, isVisible: true),
                .init(place: .side,   action: .multiplication, isEnabled: true, isVisible: true),
                .init(place: .side,   action: .minus,          isEnabled: true, isVisible: true),
                .init(place: .side,   action: .plus,           isEnabled: true, isVisible: true),
                .init(place: .side,   action: .equal,          isEnabled: true, isVisible: true),
            ])
        return viewModel
    }
}

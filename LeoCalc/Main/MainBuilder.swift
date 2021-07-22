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
                .init(place: .top,    action: Action(type: .clear),          isEnabled: true, isVisible: true),
                .init(place: .top,    action: Action(type: .sin),            isEnabled: true, isVisible: true),
                .init(place: .top,    action: Action(type: .cos),            isEnabled: true, isVisible: true),
                .init(place: .static, action: Action(type: .seven),          isEnabled: true, isVisible: true),
                .init(place: .static, action: Action(type: .eight),          isEnabled: true, isVisible: true),
                .init(place: .static, action: Action(type: .nine),           isEnabled: true, isVisible: true),
                .init(place: .static, action: Action(type: .four),           isEnabled: true, isVisible: true),
                .init(place: .static, action: Action(type: .five),           isEnabled: true, isVisible: true),
                .init(place: .static, action: Action(type: .six),            isEnabled: true, isVisible: true),
                .init(place: .static, action: Action(type: .one),            isEnabled: true, isVisible: true),
                .init(place: .static, action: Action(type: .two),            isEnabled: true, isVisible: true),
                .init(place: .static, action: Action(type: .three),          isEnabled: true, isVisible: true),
                .init(place: .static, action: Action(type: .zero),           isEnabled: true, isVisible: true),
                .init(place: .static, action: Action(type: .point),          isEnabled: true, isVisible: true),
                .init(place: .side,   action: Action(type: .bitcoin),        isEnabled: true, isVisible: true),
                .init(place: .side,   action: Action(type: .division),       isEnabled: true, isVisible: true),
                .init(place: .side,   action: Action(type: .multiplication), isEnabled: true, isVisible: true),
                .init(place: .side,   action: Action(type: .minus),          isEnabled: true, isVisible: true),
                .init(place: .side,   action: Action(type: .plus),           isEnabled: true, isVisible: true),
                .init(place: .side,   action: Action(type: .equal),          isEnabled: true, isVisible: true),
            ])
        return viewModel
    }
}

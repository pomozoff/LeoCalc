//
//  MainBuilder.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 17.07.2021.
//

import FeatureToggleKit
import Foundation

typealias FeaturesProvider = Provider<FeatureModel>

class MainBuilder {
    static func buildViewModel() -> MainViewModel {
        let jsonSource = JSONSource<FeatureModel>(fileUrl: Bundle.main.url(forResource: "featuresList", withExtension: "json")!)
        let provider = FeaturesProvider(sources: [jsonSource.anySource])
        let model = Calculator()

        let viewModel = MainViewModel(
            provider: provider,
            buttons: [
                .init(place: .top,    action: Action(type: .clear)),
                .init(place: .top,    action: Action(type: .sin)),
                .init(place: .top,    action: Action(type: .cos)),
                .init(place: .static, action: Action(type: .seven)),
                .init(place: .static, action: Action(type: .eight)),
                .init(place: .static, action: Action(type: .nine)),
                .init(place: .static, action: Action(type: .four)),
                .init(place: .static, action: Action(type: .five)),
                .init(place: .static, action: Action(type: .six)),
                .init(place: .static, action: Action(type: .one)),
                .init(place: .static, action: Action(type: .two)),
                .init(place: .static, action: Action(type: .three)),
                .init(place: .static, action: Action(type: .zero)),
                .init(place: .static, action: Action(type: .point)),
                .init(place: .side,   action: Action(type: .bitcoin)),
                .init(place: .side,   action: Action(type: .division)),
                .init(place: .side,   action: Action(type: .multiplication)),
                .init(place: .side,   action: Action(type: .minus)),
                .init(place: .side,   action: Action(type: .plus)),
                .init(place: .side,   action: Action(type: .equal)),
            ],
            model: model)
        viewModel.fetch()

        return viewModel
    }
}

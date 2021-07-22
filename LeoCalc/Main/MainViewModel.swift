//
//  MainViewModel.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 15.07.2021.
//

import FeatureToggleKit
import ViewModelKit
import UIKit

class MainViewModel {
    var updateResult: ((Double) -> Void)?

    init(provider: FeaturesProvider, buttons: [Button]) {
        self.provider = provider
        self.buttons = buttons
    }

    private let provider: FeaturesProvider
    private let buttons: [Button]
}

extension MainViewModel: ViewModel {
    typealias VC = MainViewController
}

extension MainViewModel {
    func buttonsCount(in place: ButtonPlace) -> Int {
        filteredButtons(in: place).count
    }

    func textForItem(at indexPath: IndexPath, in place: ButtonPlace) -> String? {
        let filteredButtons = filteredButtons(in: place)
        guard 0 ..< filteredButtons.count ~= indexPath.item else { return nil }
        return filteredButtons[indexPath.item].title
    }

    func buttonSize(at indexPath: IndexPath, in place: ButtonPlace, screenWidth: CGFloat) -> CGSize {
        let height = screenWidth / CGFloat(Constants.numberOfColumns)
        let width = (place == .static && filteredButtons(in: place)[indexPath.item].action.type == .zero) ? height * 2 : height

        return CGSize(width: width, height: height)
    }

    func defaultButtonSize(screenWidth: CGFloat) -> CGSize {
        buttonSize(
            at: IndexPath(item: 0, section: 0),
            in: .static,
            screenWidth: screenWidth
        )
    }

    func didSelectItem(at indexPath: IndexPath, in place: ButtonPlace) {
        
    }
}

private extension MainViewModel {
    func filteredButtons(in place: ButtonPlace) -> [Button] {
        buttons.filter { $0.place == place }
    }
}

private enum Constants {
    static let numberOfColumns = 4
    static let interItemSapce: CGFloat = 1.0
}

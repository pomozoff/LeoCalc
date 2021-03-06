//
//  MainViewModel.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 15.07.2021.
//

import Combine
import FeatureToggleKit
import ViewModelKit
import UIKit

class MainViewModel {
    var total: AnyPublisher<String, Never> {
        model.total
            .map(String.init)
            .combineLatest(model.showPoint) {
                $1 ? "\($0)." : $0
            }
            .eraseToAnyPublisher()
    }

    var showPoint: AnyPublisher<Bool, Never> {
        model.showPoint.eraseToAnyPublisher()
    }

    var isAwaiting: AnyPublisher<Bool, Never> {
        model.isAwaiting
            .combineLatest(providerLoading) {
                $0 || $1
            }
            .throttle(for: 0.1, scheduler: DispatchQueue.main, latest: true)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    var didUpdate: AnyPublisher<Void, Never> {
        _didUpdate.eraseToAnyPublisher()
    }

    var userError: AnyPublisher<UserError, Never> {
        model.calcError
            .map { UserError(code: .internal, localizedFailureReason: $0.localizedFailureReason, underlying: $0) }
            .merge(with: providerError.map { UserError(code: .external, localizedFailureReason: $0.localizedFailureReason, underlying: $0) })
            .eraseToAnyPublisher()
    }

    init(
        provider: FeaturesProvider,
        buttons: [Button],
        model: Calculable
    ) {
        self.provider = provider
        self.buttons = buttons
        self.model = model

        setupBindings()
    }

    private let provider: FeaturesProvider
    private var buttons: [Button]
    private let model: Calculable

    private let _didUpdate = PassthroughSubject<Void, Never>()
    private let providerLoading = CurrentValueSubject<Bool, Never>(false)
    private let providerError = PassthroughSubject<ProviderError, Never>()

    private var showPointCancellable = AnyCancellable {}
    private var isCleanedCancellable = AnyCancellable {}
}

extension MainViewModel: ViewModel {
    typealias VC = MainViewController
}

extension MainViewModel {
    func fetch() -> Void {
        providerLoading.send(true)
        provider.fetch { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success():
                    self.updateButtonsIfNeeded()
                case let .failure(error):
                    self.providerError.send(error)
                }
                self.providerLoading.send(false)
            }
        }
    }

    func buttonsCount(in place: ButtonPlace) -> Int {
        filteredButtons(in: place).count
    }

    func textForItem(at indexPath: IndexPath, in place: ButtonPlace) -> String? {
        button(at: indexPath, in: place)?.title
    }

    func buttonSize(at indexPath: IndexPath, in place: ButtonPlace, screenWidth: CGFloat) -> CGSize {
        let height = (screenWidth - CGFloat(Constants.numberOfColumns - 1)) / CGFloat(Constants.numberOfColumns)
        let width: CGFloat

        if place == .static, let button = button(at: indexPath, in: place) {
            width = (button.action.type == .zero) ? height * 2 + 1.0 : height
        } else {
            width = height
        }

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
        guard let button = button(at: indexPath, in: place) else { return }
        model.didReceive(action: button.action)
    }
}

private extension MainViewModel {
    func setupBindings() {
        isCleanedCancellable = model.isCleaned
            .removeDuplicates()
            .sink { [weak self] in
                guard let self = self else { return }

                self.updateClearButton(value: $0)
                self._didUpdate.send(())
            }
    }

    func updateClearButton(value: Bool) {
        guard let button = buttons.first(where: { $0.action.type == .clear }) else { return }
        button.action.updateName(with: value ? "AC" : "C")
    }

    func filteredButtons(in place: ButtonPlace) -> [Button] {
        buttons.filter { $0.isEnabled && $0.place == place }
    }

    func button(at indexPath: IndexPath, in place: ButtonPlace) -> Button? {
        let filteredButtons = filteredButtons(in: place)
        guard 0 ..< filteredButtons.count ~= indexPath.item else { return nil }
        return filteredButtons[indexPath.item]
    }

    func updateButtonsIfNeeded() {
        for button in buttons {
            guard button.isEnabled != isFeatureEnabled(name: button.title) else { continue }

            buttons = buttons.reduce(into: []) { result, button in
                let isEnabled = isFeatureEnabled(name: button.title)
                let action = button.action.copy(isEnabled: isEnabled)
                let newButton = Button(place: button.place, action: action)

                result.append(newButton)
            }
            _didUpdate.send(())

            break
        }
    }

    func isFeatureEnabled(name: String) -> Bool {
        provider.model(with: name)?.isEnabled ?? false
    }
}

private enum Constants {
    static let numberOfColumns = 4
    static let interItemSapce: CGFloat = 1.0
}

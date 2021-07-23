//
//  MainViewController.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 15.07.2021.
//

import Combine
import UIKit
import ViewModelKit

class MainViewController: UIViewController {
    private(set) var viewModel: MainViewModel?

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        mainView.buttonHeight = viewModel?.defaultButtonSize(screenWidth: view.bounds.width).height ?? .zero

        invalidateLayouts()
    }

    let topCollectionLayout: SingleLineButtonsCollectionLayout = {
        let layout = SingleLineButtonsCollectionLayout()
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0

        return layout
    }()

    let staticCollectionLayout: StaticButtonsCollectionLayout = {
        let layout = StaticButtonsCollectionLayout()
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0

        return layout
    }()

    let sideCollectionLayout: SingleLineButtonsCollectionLayout = {
        let layout = SingleLineButtonsCollectionLayout()
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0

        return layout
    }()

    private lazy var mainView: MainView = {
        let view = MainView(
            topCollectionLayout: topCollectionLayout,
            staticCollectionLayout: staticCollectionLayout,
            sideCollectionLayout: sideCollectionLayout
        )

        view.topButtonsCollection.delegate = self
        view.topButtonsCollection.dataSource = self

        view.staticButtonsCollection.delegate = self
        view.staticButtonsCollection.dataSource = self

        view.sideButtonsCollection.delegate = self
        view.sideButtonsCollection.dataSource = self

        return view
    }()

    private var totalCancellable = AnyCancellable {}
    private var isAwaitingCancellable = AnyCancellable {}
    private var didUpdateCancellable = AnyCancellable {}
}

// MARK: - ViewModelConfigurable

extension MainViewController: ViewModelOwnable {
    func configure(with viewModel: MainViewModel) {
        self.viewModel = viewModel

        totalCancellable = viewModel.total
            .sink { [unowned self] in
                mainView.resultText = String(describing: $0)
            }

        isAwaitingCancellable = viewModel.isAwaiting
            .sink { [unowned self] in
                mainView.isActivityIndicatorViewShown = $0
            }

        didUpdateCancellable = viewModel.didUpdate
            .sink { [unowned self] in
                // FIXME: Reload only updated buttons
                reloadButtons()
            }

        reloadButtons()
    }
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }

        let numberOfItems: Int

        if collectionView === mainView.topButtonsCollection {
            numberOfItems = viewModel.buttonsCount(in: .top)
        } else if collectionView === mainView.staticButtonsCollection {
            numberOfItems = viewModel.buttonsCount(in: .static)
        } else if collectionView === mainView.sideButtonsCollection {
            numberOfItems = viewModel.buttonsCount(in: .side)
        } else {
            numberOfItems = 0
        }

        return numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var text: String?

        if collectionView === mainView.topButtonsCollection {
            text = viewModel?.textForItem(at: indexPath, in: .top)
        } else if collectionView === mainView.staticButtonsCollection {
            text = viewModel?.textForItem(at: indexPath, in: .static)
        } else if collectionView === mainView.sideButtonsCollection {
            text = viewModel?.textForItem(at: indexPath, in: .side)
        }

        let label = createCellTitleLabel(with: text)

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionView.reuseIdentifier, for: indexPath)
        cell.contentView.addSubview(label)
        cell.contentView.clipsToBounds = true

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
        ])

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === mainView.topButtonsCollection {
            viewModel?.didSelectItem(at: indexPath, in: .top)
        } else if collectionView === mainView.staticButtonsCollection {
            viewModel?.didSelectItem(at: indexPath, in: .static)
        } else if collectionView === mainView.sideButtonsCollection {
            viewModel?.didSelectItem(at: indexPath, in: .side)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize?

        if collectionView === mainView.topButtonsCollection {
            size = viewModel?.buttonSize(at: indexPath, in: .top, screenWidth: view.bounds.width)
        } else if collectionView === mainView.staticButtonsCollection {
            size = viewModel?.buttonSize(at: indexPath, in: .static, screenWidth: view.bounds.width)
        } else if collectionView === mainView.sideButtonsCollection {
            size = viewModel?.buttonSize(at: indexPath, in: .side, screenWidth: view.bounds.width)
        }

        return size ?? .zero
    }
}

// MARK: - Private

private extension MainViewController {
    func invalidateLayouts() {
        topCollectionLayout.invalidateLayout()
        staticCollectionLayout.invalidateLayout()
        sideCollectionLayout.invalidateLayout()
    }

    func reloadButtons() {
        mainView.topButtonsCollection.reloadData()
        mainView.staticButtonsCollection.reloadData()
        mainView.sideButtonsCollection.reloadData()
    }

    func createCellTitleLabel(with text: String?) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.buttonFontSize)
        label.backgroundColor = .systemGray5
        label.textAlignment = .center
        label.text = text

        return label
    }
}

private enum Constants {
    static let buttonFontSize: CGFloat = 32.0
}

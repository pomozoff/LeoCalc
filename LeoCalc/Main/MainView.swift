//
//  MainView.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 17.07.2021.
//

import Combine
import UIKit

class MainView: UIView {
    @Published
    var total = ""

    var buttonHeight: CGFloat = 0.0 {
        didSet {
            updateCollectionsSize(with: buttonHeight)
        }
    }

    @Published
    var isActivityIndicatorViewShown = false

    init(
        topCollectionLayout: UICollectionViewLayout,
        staticCollectionLayout: UICollectionViewLayout,
        sideCollectionLayout: UICollectionViewLayout
    ) {
        self.topCollectionLayout = topCollectionLayout
        self.staticCollectionLayout = staticCollectionLayout
        self.sideCollectionLayout = sideCollectionLayout

        super.init(frame: .zero)

        setupView()
        setupConstraints()
        setupBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var sideButtonsCollectionWidthConstraint: NSLayoutConstraint? {
        willSet {
            sideButtonsCollectionWidthConstraint?.isActive = false
        }
    }

    private var topButtonsCollectionHeightConstraint: NSLayoutConstraint? {
        willSet {
            topButtonsCollectionHeightConstraint?.isActive = false
        }
    }

    private let topCollectionLayout: UICollectionViewLayout
    private let staticCollectionLayout: UICollectionViewLayout
    private let sideCollectionLayout: UICollectionViewLayout

    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "0" // FIXME: Set value from a model
        label.font = .systemFont(ofSize: Constants.resultFontSize)
        label.backgroundColor = .systemGray6
        label.textAlignment = .right

        label.layer.cornerRadius = Constants.cornerRadius
        label.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        label.layer.masksToBounds = true

        return label
    }()

    private let verticalButtonsContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical

        // TODO: Check the corner radius is applied
        stack.layer.cornerRadius = Constants.cornerRadius
        stack.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        stack.layer.masksToBounds = true

        return stack
    }()

    private(set) lazy var topButtonsCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: topCollectionLayout)
        collection.backgroundColor = .systemGray5
        collection.reuseIdentifier = "topCellsReuseIdentifier"
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collection.reuseIdentifier)

        return collection
    }()

    private let horizontalButtonsContainer = UIStackView()

    private(set) lazy var staticButtonsCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: staticCollectionLayout)
        collection.backgroundColor = .systemGray5
        collection.reuseIdentifier = "staticCellsReuseIdentifier"
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collection.reuseIdentifier)

        return collection
    }()

    private(set) lazy var sideButtonsCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: sideCollectionLayout)
        collection.backgroundColor = .systemGray5
        collection.reuseIdentifier = "sideCellsReuseIdentifier"
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collection.reuseIdentifier)

        return collection
    }()

    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3.withAlphaComponent(0.7)
        view.alpha = 0.0
        view.isHidden = true

        return view
    }()

    private let activityIndicatorView = UIActivityIndicatorView(style: .large)

    private var resultCancellable = AnyCancellable {}
    private var isAwaitingCancellable = AnyCancellable {}
}

private extension MainView {
    func setupView() {
        backgroundColor = .systemGray5
    }

    func setupConstraints() {
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(resultLabel)
        NSLayoutConstraint.activate([
            resultLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            resultLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            resultLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
        ])

        horizontalButtonsContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalButtonsContainer)
        NSLayoutConstraint.activate([
            horizontalButtonsContainer.leadingAnchor.constraint(equalTo: resultLabel.leadingAnchor),
            horizontalButtonsContainer.trailingAnchor.constraint(equalTo: resultLabel.trailingAnchor),
            horizontalButtonsContainer.topAnchor.constraint(equalTo: resultLabel.bottomAnchor),
            horizontalButtonsContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])

        horizontalButtonsContainer.addArrangedSubview(verticalButtonsContainer)
        horizontalButtonsContainer.addArrangedSubview(sideButtonsCollection)

        verticalButtonsContainer.addArrangedSubview(topButtonsCollection)
        verticalButtonsContainer.addArrangedSubview(staticButtonsCollection)

        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dimmedView)
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dimmedView.topAnchor.constraint(equalTo: self.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        dimmedView.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: dimmedView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: dimmedView.centerYAnchor),
        ])
    }

    func setupBindings() {
        resultCancellable = $total
            .sink { [unowned self] in
                resultLabel.text = $0
            }

        isAwaitingCancellable = $isActivityIndicatorViewShown
            .sink { [unowned self] isShown in
                isShown ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()

                UIView.animate(
                    withDuration: Constants.animationDuration,
                    delay: 0.0,
                    options: isShown ? .curveEaseOut : .curveEaseIn,
                    animations: {
                        self.dimmedView.alpha = isShown ? 1.0 : 0.0
                        if isShown {
                            self.dimmedView.isHidden = false
                        }
                    },
                    completion: { isFinished in
                        guard isFinished else { return }
                        if !isShown {
                            self.dimmedView.isHidden = true
                        }
                    }
                )
        }
    }

    func updateCollectionsSize(with buttonHeight: CGFloat) {
        sideButtonsCollectionWidthConstraint = {
            let constraint = sideButtonsCollection.widthAnchor.constraint(equalToConstant: buttonHeight)
            constraint.isActive = true
            return constraint
        }()

        topButtonsCollectionHeightConstraint = {
            let constraint = topButtonsCollection.heightAnchor.constraint(equalToConstant: buttonHeight * 2)
            constraint.isActive = true
            return constraint
        }()
    }
}

private enum Constants {
    static let viewPadding: CGFloat = 8.0
    static let resultFontSize: CGFloat = 48.0
    static let cornerRadius: CGFloat = 4.0
    static let buttonFontSize: CGFloat = 32.0
    static let buttonHeight: CGFloat = 64.0
    static let animationDuration: TimeInterval = 0.15
}

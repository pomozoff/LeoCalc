//
//  MainView.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 17.07.2021.
//

import UIKit

class MainView: UIView {
    var buttonHeight: CGFloat = 0.0 {
        didSet {
            updateCollectionsSize(with: buttonHeight)
        }
    }

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

    private let horizontalButtonsContainer: UIStackView = {
        let stack = UIStackView()
        return stack
    }()

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
}

extension MainView {
    var resultText: String? {
        get { resultLabel.text }
        set { resultLabel.text = newValue }
    }

    var clearButtonText: String? {
        get { resultLabel.text }
        set { resultLabel.text = newValue }
    }
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
    static let resultFontSize: CGFloat = 64.0
    static let cornerRadius: CGFloat = 4.0
    static let buttonFontSize: CGFloat = 32.0
    static let buttonHeight: CGFloat = 64.0
}

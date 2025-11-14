//
//  MessagesHeader.swift
//  Tinder
//
//  Created by Edwin Cardenas on 11/14/25.
//

import UIKit

class MessagesHeader: UIView {

    // MARK: - Properties

    private let newMatchesLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "New Matches"
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .systemPink

        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(
            MatchCell.self,
            forCellWithReuseIdentifier: NSStringFromClass(MatchCell.self)
        )

        return collection
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Helpers

extension MessagesHeader {

    private func setupViews() {
        addSubview(newMatchesLabel)
        addSubview(collectionView)

        // newMatchesLabel
        NSLayoutConstraint.activate([
            newMatchesLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 16
            ),
            newMatchesLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
        ])

        // collectionView
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: newMatchesLabel.bottomAnchor,
                constant: 16
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: newMatchesLabel.leadingAnchor
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -16
            ),
        ])
    }

}

// MARK: - UICollectionViewDataSource

extension MessagesHeader: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 10
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NSStringFromClass(MatchCell.self),
                for: indexPath
            ) as? MatchCell
        else {
            fatalError("Could not initialize MatchCell.")
        }

        return cell
    }

}

// MARK: - UICollectionViewDelegate

extension MessagesHeader: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDelegateFlowLayout

extension MessagesHeader: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 80, height: 108)
    }

}

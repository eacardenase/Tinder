//
//  MessagesHeader.swift
//  Tinder
//
//  Created by Edwin Cardenas on 11/14/25.
//

import UIKit

protocol MessagesHeaderDelegate: AnyObject {

    func messagesHeader(
        _ header: MessagesHeader,
        wantsToChatWith user: User
    )

}

enum MessagesHeaderSections: Int, CaseIterable {

    case likes
    case matches

}

class MessagesHeader: UIView {

    // MARK: - Properties

    weak var delegate: MessagesHeaderDelegate?

    var profileImageUrl: URL? {
        didSet { collectionView.reloadData() }
    }

    var likesCount: Int? {
        didSet { collectionView.reloadData() }
    }

    var matches = [Match]() {
        didSet {
            collectionView.reloadData()
        }
    }

    private let newMatchesLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "New Matches"
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .systemPink

        return label
    }()

    private let collectionViewLayout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(80),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(90),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal

        return UICollectionViewCompositionalLayout(
            section: section,
            configuration: config
        )
    }()

    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )

        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.bounces = false
        collection.register(
            MatchCell.self,
            forCellWithReuseIdentifier: NSStringFromClass(MatchCell.self)
        )
        collection.register(
            LikesCell.self,
            forCellWithReuseIdentifier: NSStringFromClass(LikesCell.self)
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
                equalTo: bottomAnchor
            ),
        ])
    }

}

// MARK: - UICollectionViewDataSource

extension MessagesHeader: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return MessagesHeaderSections.allCases.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard
            let headerSection =
                MessagesHeaderSections(rawValue: section)
        else {
            fatalError(
                "Could not instantiate MessagesHeaderSections from raw value."
            )
        }

        switch headerSection {
        case .likes: return 1
        case .matches: return matches.count
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let section =
                MessagesHeaderSections(rawValue: indexPath.section)
        else {
            fatalError(
                "Could not instantiate MessagesHeaderSections from raw value."
            )
        }

        switch section {
        case .likes:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: NSStringFromClass(LikesCell.self),
                    for: indexPath
                ) as? LikesCell
            else {
                fatalError("Could not initialize LikesCell.")
            }

            let viewModel = LikesCellViewModel(
                count: likesCount,
                profileImageUrl: profileImageUrl
            )

            cell.viewModel = viewModel

            return cell
        case .matches:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: NSStringFromClass(MatchCell.self),
                    for: indexPath
                ) as? MatchCell
            else {
                fatalError("Could not initialize MatchCell.")
            }

            cell.match = matches[indexPath.item]

            return cell
        }
    }

}

// MARK: - UICollectionViewDelegate

extension MessagesHeader: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        guard
            let section =
                MessagesHeaderSections(rawValue: indexPath.section)
        else {
            fatalError(
                "Could not instantiate MessagesHeaderSections from raw value."
            )
        }

        if case .likes = section {
            return false
        }

        return true
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let match = matches[indexPath.item]

        UserService.fetchUser(withId: match.profileUid) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let user):
                self.delegate?.messagesHeader(
                    self,
                    wantsToChatWith: user
                )
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

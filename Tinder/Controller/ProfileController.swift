//
//  ProfileController.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/17/25.
//

import UIKit

protocol ProfileControllerDelegate: AnyObject {

    func profileController(
        _ controller: ProfileController,
        wantsToSwipeTo direction: SwipeDirection
    )

}

class ProfileController: UIViewController {

    // MARK: - Properties

    let viewModel: ProfileViewModel
    weak var delegate: ProfileControllerDelegate?

    private let collectionViewLayout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
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
        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.register(
            ProfileCell.self,
            forCellWithReuseIdentifier: NSStringFromClass(
                ProfileCell.self
            )
        )

        return collection
    }()

    private lazy var barStackView = SegmentedBarView(
        numberOfSegments: viewModel.imageUrls.count
    )

    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .dismissDownArrow).withRenderingMode(
            .alwaysOriginal
        )

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.addTarget(
            self,
            action: #selector(dismissButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var infoLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.attributedText = viewModel.userDetailsAttributedString

        return label
    }()

    private lazy var professionLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.profesion
        label.font = .preferredFont(forTextStyle: .body)

        return label
    }()

    private lazy var bioLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.bio
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .body)

        return label
    }()

    private let profileControls = ProfileControls()

    // MARK: - Initializers

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        profileControls.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

}

// MARK: - Helpers

extension ProfileController {

    private func setupViews() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white

        let infoStackView = UIStackView(arrangedSubviews: [
            infoLabel, professionLabel, bioLabel,
        ])

        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.axis = .vertical
        infoStackView.spacing = 8

        view.addSubview(collectionView)
        view.addSubview(barStackView)
        view.addSubview(dismissButton)
        view.addSubview(infoStackView)
        view.addSubview(profileControls)

        // collectionView
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
            collectionView.heightAnchor.constraint(
                equalTo: collectionView.widthAnchor,
                constant: 50
            ),
        ])

        // barStackView
        NSLayoutConstraint.activate([
            barStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 8
            ),
            barStackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 8
            ),
            barStackView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -8
            ),
        ])

        // dismissButton
        NSLayoutConstraint.activate([
            dismissButton.centerYAnchor.constraint(
                equalTo: collectionView.bottomAnchor
            ),
            dismissButton.trailingAnchor.constraint(
                equalTo: collectionView.trailingAnchor,
                constant: -24
            ),
            dismissButton.heightAnchor.constraint(equalToConstant: 50),
            dismissButton.widthAnchor.constraint(
                equalTo: dismissButton.heightAnchor
            ),
        ])

        // infoStackView
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(
                equalTo: collectionView.bottomAnchor,
                constant: 16
            ),
            infoStackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            infoStackView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
        ])

        // controlsStackView
        NSLayoutConstraint.activate([
            profileControls.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            profileControls.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -32
            ),
        ])
    }

}

// MARK: - UICollectionViewDataSource

extension ProfileController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.imageCount
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NSStringFromClass(ProfileCell.self),
                for: indexPath
            ) as? ProfileCell
        else {
            fatalError("Could not instantiate ProfileCell")
        }

        cell.imageUrl = viewModel.imageUrls[indexPath.item]

        return cell
    }

}

// MARK: - UICollectionViewDelegate

extension ProfileController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        barStackView.highlightSegment(at: indexPath.item)
    }

}

// MARK: - Actions

extension ProfileController {

    @objc func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

}

// MARK: - ProfileControlsDelegate

extension ProfileController: ProfileControlsDelegate {

    func handleLike() {
        delegate?.profileController(self, wantsToSwipeTo: .right)
    }

    func handleDislike() {
        delegate?.profileController(self, wantsToSwipeTo: .left)
    }

}

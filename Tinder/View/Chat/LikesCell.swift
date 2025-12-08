//
//  LikesMatchCell.swift
//  Tinder
//
//  Created by Edwin Cardenas on 12/6/25.
//

import UIKit

class LikesCell: UICollectionViewCell {

    // MARK: - Properties

    var viewModel: LikesCellViewModel? {
        didSet { configure() }
    }

    private let containerView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.systemYellow.cgColor
        view.clipsToBounds = true

        return view
    }()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemYellow
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)

        let visualEffect = UIVisualEffectView(effect: blurEffect)
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        visualEffect.clipsToBounds = true

        return visualEffect
    }()

    private let likesContainer: UIView = {
        let container = UIView()

        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .systemYellow

        return container
    }()

    private let likesLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true

        guard
            let fontDescriptor: UIFontDescriptor = .preferredFontDescriptor(
                withTextStyle: .body
            ).withSymbolicTraits(.traitBold)
        else {
            fatalError("Could not instantiate font descriptor with bold trait.")
        }

        label.font = UIFont(descriptor: fontDescriptor, size: 0)

        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.text = "Likes"
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .headline)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)

        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func layoutSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        visualEffectView.layer.cornerRadius = visualEffectView.frame.height / 2

        likesContainer.layer.cornerRadius = likesContainer.frame.height / 2
    }

}

// MARK: - Helpers

extension LikesCell {

    private func setupViews() {
        likesContainer.addSubview(likesLabel)

        // likesContainer
        NSLayoutConstraint.activate([
            likesLabel.centerXAnchor.constraint(
                equalTo: likesContainer.centerXAnchor
            ),
            likesLabel.centerYAnchor.constraint(
                equalTo: likesContainer.centerYAnchor
            ),
        ])

        containerView.addSubview(profileImageView)
        containerView.addSubview(visualEffectView)
        containerView.addSubview(likesContainer)

        // profileImageView
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: 7
            ),
            profileImageView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 7
            ),
            profileImageView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -7
            ),
            profileImageView.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: -7
            ),
        ])

        // visualEffectView
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(
                equalTo: profileImageView.topAnchor
            ),
            visualEffectView.leadingAnchor.constraint(
                equalTo: profileImageView.leadingAnchor
            ),
            visualEffectView.trailingAnchor.constraint(
                equalTo: profileImageView.trailingAnchor
            ),
            visualEffectView.bottomAnchor.constraint(
                equalTo: profileImageView.bottomAnchor
            ),
        ])

        // likesLabel
        NSLayoutConstraint.activate([
            likesContainer.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: 20
            ),
            likesContainer.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 20
            ),
            likesContainer.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -20
            ),
            likesContainer.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: -20
            ),
        ])

        let stackView = UIStackView(arrangedSubviews: [
            containerView,
            titleLabel,
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 8

        contentView.addSubview(stackView)

        let containerViewHeightAnchor = containerView.heightAnchor.constraint(
            equalToConstant: 80
        )

        // profileImageView
        NSLayoutConstraint.activate([
            containerViewHeightAnchor,
            containerView.widthAnchor.constraint(
                equalToConstant: containerViewHeightAnchor.constant
            ),
        ])

        // stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            stackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            stackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),
        ])

        containerView.layer.cornerRadius =
            containerViewHeightAnchor.constant / 2
    }

    private func configure() {
        guard let viewModel else { return }

        likesLabel.text = viewModel.likesCountText
        titleLabel.text = viewModel.titleText

        guard let imageUrl = URL(string: viewModel.profileImageUrl)
        else { return }

        profileImageView.sd_setImage(with: imageUrl)

    }

}

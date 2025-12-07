//
//  LikesMatchCell.swift
//  Tinder
//
//  Created by Edwin Cardenas on 12/6/25.
//

import UIKit

class LikesCell: UICollectionViewCell {

    // MARK: - Properties

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
        imageView.backgroundColor = .systemYellow.withAlphaComponent(0.3)
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    private let likesLabel: UILabel = {
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
    }

}

// MARK: - Helpers

extension LikesCell {

    private func setupViews() {
        containerView.addSubview(profileImageView)

        // containerView
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: 6
            ),
            profileImageView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 6
            ),
            profileImageView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -6
            ),
            profileImageView.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: -6
            ),
        ])

        let stackView = UIStackView(arrangedSubviews: [
            containerView,
            likesLabel,
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

}

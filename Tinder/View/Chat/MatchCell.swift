//
//  MatchCell.swift
//  Tinder
//
//  Created by Edwin Cardenas on 11/14/25.
//

import UIKit

class MatchCell: UICollectionViewCell {

    // MARK: - Properties

    var match: Match? {
        didSet { configure() }
    }

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    private let bubbleView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemPink
        view.layer.borderWidth = 2.5
        view.layer.borderColor = UIColor.white.cgColor

        return view
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()

        label.textColor = .darkGray
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1

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

}

// MARK: - Helpers

extension MatchCell {

    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [
            profileImageView,
            usernameLabel,
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 8

        contentView.addSubview(stackView)

        let imageViewHeightAnchor = profileImageView.heightAnchor.constraint(
            equalToConstant: 80
        )

        // profileImageView
        NSLayoutConstraint.activate([
            imageViewHeightAnchor,
            profileImageView.widthAnchor.constraint(
                equalToConstant: imageViewHeightAnchor.constant
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

        contentView.addSubview(bubbleView)

        let bubbleViewHeightAnchor = bubbleView.heightAnchor.constraint(
            equalToConstant: 16
        )

        // bubbleView
        NSLayoutConstraint.activate([
            bubbleViewHeightAnchor,
            bubbleView.widthAnchor.constraint(equalTo: bubbleView.heightAnchor),
            bubbleView.centerYAnchor.constraint(
                equalTo: profileImageView.centerYAnchor
            ),
            bubbleView.centerXAnchor.constraint(
                equalTo: profileImageView.trailingAnchor
            ),
        ])

        profileImageView.layer.cornerRadius = imageViewHeightAnchor.constant / 2
        bubbleView.layer.cornerRadius = bubbleViewHeightAnchor.constant / 2
    }

    private func configure() {
        guard let match else { return }

        let viewModel = MatchCellViewModel(match: match)

        usernameLabel.text = viewModel.nameText
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }

}

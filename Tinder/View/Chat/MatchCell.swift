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

    private let usernameLabel: UILabel = {
        let label = UILabel()

        label.textColor = .darkGray
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 2
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

        profileImageView.layer.cornerRadius = imageViewHeightAnchor.constant / 2
    }

    private func configure() {
        guard let match else { return }

        let viewModel = MatchCellViewModel(match: match)

        usernameLabel.text = viewModel.nameText
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }

}

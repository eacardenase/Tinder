//
//  ConversationCell.swift
//  Tinder
//
//  Created by Edwin Cardenas on 11/26/25.
//

import UIKit

class ConversationCell: UITableViewCell {

    // MARK: - Properties

    var conversation: Conversation? {
        didSet {
            configure()
        }
    }

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemPink.withAlphaComponent(0.5)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()

        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .black

        return label
    }()

    private let messageTextLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .black

        return label
    }()

    private let timestampLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .darkGray

        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        return label
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Helpers

extension ConversationCell {

    private func setupViews() {
        backgroundColor = .white

        let stackView = UIStackView(arrangedSubviews: [
            usernameLabel,
            messageTextLabel,
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4

        contentView.addSubview(profileImageView)
        contentView.addSubview(stackView)
        contentView.addSubview(timestampLabel)

        let profileImageHeightAnchor = profileImageView.heightAnchor.constraint(
            equalToConstant: 50
        )
        profileImageHeightAnchor.priority = UILayoutPriority(900)

        // profileImageView
        NSLayoutConstraint.activate([
            profileImageHeightAnchor,
            profileImageView.widthAnchor.constraint(
                equalTo: profileImageView.heightAnchor
            ),
            profileImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 8
            ),
            profileImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            profileImageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -8
            ),
        ])

        profileImageView.layer.cornerRadius =
            profileImageHeightAnchor.constant / 2

        // stackView
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            stackView.leadingAnchor.constraint(
                equalTo: profileImageView.trailingAnchor,
                constant: 16
            ),
        ])

        // timestampLabel
        NSLayoutConstraint.activate([
            timestampLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            timestampLabel.leadingAnchor.constraint(
                equalTo: stackView.trailingAnchor,
                constant: 16
            ),
            timestampLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
        ])
    }

    private func configure() {
        guard let conversation else { return }
        let viewModel = ConversationViewModel(conversation: conversation)

        usernameLabel.text = viewModel.username
        messageTextLabel.text = viewModel.text
        timestampLabel.text = viewModel.timestamp

        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }

}

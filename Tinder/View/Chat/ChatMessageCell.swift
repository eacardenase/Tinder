//
//  ChatMessageCell.swift
//  Tinder
//
//  Created by Edwin Cardenas on 11/26/25.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {

    // MARK: - Properties

    var message: Message? {
        didSet {
            configure()
        }
    }

    var bubbleLeadingAnchor = NSLayoutConstraint()
    var bubbleTrailingAnchor = NSLayoutConstraint()

    private let textView: UITextView = {
        let _textView = UITextView()

        _textView.translatesAutoresizingMaskIntoConstraints = false
        _textView.textColor = .white
        _textView.backgroundColor = .clear
        _textView.font = .systemFont(ofSize: 16)
        _textView.isScrollEnabled = false
        _textView.isUserInteractionEnabled = false
        _textView.clipsToBounds = true

        return _textView
    }()

    private let timestampLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .white
        label.textAlignment = .right

        return label
    }()

    private let bubbleContainer: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemPink

        return view
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

extension ChatMessageCell {

    private func setupViews() {
        bubbleContainer.addSubview(textView)
        bubbleContainer.addSubview(timestampLabel)

        contentView.addSubview(bubbleContainer)

        // bubbleContainer

        bubbleTrailingAnchor = bubbleContainer.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: -12
        )
        bubbleLeadingAnchor = bubbleContainer.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: 12
        )

        let bubbleWidthAnchor = bubbleContainer.widthAnchor.constraint(
            lessThanOrEqualToConstant: 250
        )
        bubbleWidthAnchor.priority = UILayoutPriority(900)

        NSLayoutConstraint.activate([
            bubbleContainer.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            bubbleContainer.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),
            bubbleWidthAnchor,
        ])

        bubbleContainer.layer.cornerRadius = 12

        // textView
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(
                equalTo: bubbleContainer.topAnchor,
                constant: 4
            ),
            textView.leadingAnchor.constraint(
                equalTo: bubbleContainer.leadingAnchor,
                constant: 12
            ),
            textView.trailingAnchor.constraint(
                equalTo: bubbleContainer.trailingAnchor,
                constant: -12
            ),
        ])

        // timestampLabel
        NSLayoutConstraint.activate([
            timestampLabel.topAnchor.constraint(
                equalTo: textView.bottomAnchor,
            ),
            timestampLabel.leadingAnchor.constraint(
                equalTo: textView.leadingAnchor
            ),
            timestampLabel.trailingAnchor.constraint(
                equalTo: textView.trailingAnchor
            ),
            timestampLabel.bottomAnchor.constraint(
                equalTo: bubbleContainer.bottomAnchor,
                constant: -6
            ),
        ])
    }

    private func configure() {
        guard let message else { return }

        let viewModel = ChatMessageCellViewModel(message: message)

        bubbleContainer.backgroundColor = viewModel.messageBackgroundColor

        textView.text = message.text
        textView.textColor = viewModel.messageTextColor

        timestampLabel.text = viewModel.timestamp

        bubbleLeadingAnchor.isActive = viewModel.leadingAnchorActive
        bubbleTrailingAnchor.isActive = viewModel.trailingAnchorActive
    }

}

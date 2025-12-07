//
//  LikesMatchCell.swift
//  Tinder
//
//  Created by Edwin Cardenas on 12/6/25.
//

import UIKit

class LikesCell: UICollectionViewCell {

    // MARK: - Properties

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.systemYellow.cgColor

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

}

// MARK: - Helpers

extension LikesCell {

    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [
            profileImageView,
            likesLabel,
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

}

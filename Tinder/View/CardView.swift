//
//  CardView.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/6/25.
//

import UIKit

class CardView: UIView {

    // MARK: - Properties

    private let imageView: UIImageView = {
        let _imageView = UIImageView()

        _imageView.translatesAutoresizingMaskIntoConstraints = false
        _imageView.contentMode = .scaleAspectFill
        _imageView.image = UIImage(resource: .jane1)

        return _imageView
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()

        let attributedText = NSMutableAttributedString(
            string: "Jane Doe",
            attributes: [
                .font: UIFont.systemFont(ofSize: 32, weight: .heavy),
                .foregroundColor: UIColor.white,
            ]
        )

        attributedText.append(
            NSAttributedString(
                string: "  18",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 24),
                    .foregroundColor: UIColor.white,
                ]
            )
        )

        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.attributedText = attributedText

        return label
    }()

    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .infoIcon).withRenderingMode(
            .alwaysOriginal
        )

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)

        return button
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

extension CardView {

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        addSubview(infoLabel)
        addSubview(infoButton)

        // imageView
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        // infoLabel
        NSLayoutConstraint.activate([
            infoLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            infoLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            infoLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -16
            ),
        ])

        // infoButton
        NSLayoutConstraint.activate([
            infoButton.heightAnchor.constraint(equalToConstant: 40),
            infoButton.widthAnchor.constraint(equalTo: infoButton.heightAnchor),
            infoButton.centerYAnchor.constraint(
                equalTo: infoLabel.centerYAnchor
            ),
            infoButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
        ])
    }

}

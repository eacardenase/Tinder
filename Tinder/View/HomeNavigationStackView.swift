//
//  HomeNavigationStackView.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/4/25.
//

import UIKit

class HomeNavigationStackView: UIStackView {

    // MARK: - Properties

    let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .topLeftProfile).withRenderingMode(
            .alwaysOriginal
        )

        button.setImage(image, for: .normal)

        return button
    }()

    let tinderIcon: UIImageView = {
        let imageView = UIImageView()

        imageView.image = UIImage(resource: .appIcon)
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)

        return imageView
    }()

    let messageButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .topMessagesIcon).withRenderingMode(
            .alwaysOriginal
        )

        button.setImage(image, for: .normal)

        return button
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Helpers

extension HomeNavigationStackView {

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false

        [settingsButton, tinderIcon, messageButton].forEach {
            addArrangedSubview($0)
        }

        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 0,
            trailing: 16
        )
    }

}

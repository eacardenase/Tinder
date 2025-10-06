//
//  BottomControlsStackView.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/4/25.
//

import UIKit

class BottomControlsStackView: UIStackView {

    // MARK: - Properties

    let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .refreshCircle).withRenderingMode(
            .alwaysOriginal
        )

        button.setImage(image, for: .normal)

        return button
    }()

    let dislikeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .dismissCircle).withRenderingMode(
            .alwaysOriginal
        )

        button.setImage(image, for: .normal)

        return button
    }()

    let superLikeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .superLikeCircle).withRenderingMode(
            .alwaysOriginal
        )

        button.setImage(image, for: .normal)

        return button
    }()

    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .likeCircle).withRenderingMode(
            .alwaysOriginal
        )

        button.setImage(image, for: .normal)

        return button
    }()

    let boostButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .boostCircle).withRenderingMode(
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

extension BottomControlsStackView {

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false

        [
            refreshButton,
            dislikeButton,
            superLikeButton,
            likeButton,
            boostButton,
        ].forEach { addArrangedSubview($0) }

        distribution = .equalCentering
    }

}

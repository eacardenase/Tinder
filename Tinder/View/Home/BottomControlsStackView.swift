//
//  BottomControlsStackView.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/4/25.
//

import UIKit

protocol BottomControlsStackViewDelegate: ProfileControlsDelegate {

    func handleRefresh()

}

class BottomControlsStackView: UIStackView {

    // MARK: - Properties

    weak var delegate: BottomControlsStackViewDelegate?

    private lazy var refreshButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .refreshCircle).withRenderingMode(
            .alwaysOriginal
        )

        button.setImage(image, for: .normal)
        button.addTarget(
            self,
            action: #selector(refreshButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var dislikeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .dismissCircle).withRenderingMode(
            .alwaysOriginal
        )

        button.setImage(image, for: .normal)
        button.addTarget(
            self,
            action: #selector(dislikeButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    private let superLikeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .superLikeCircle).withRenderingMode(
            .alwaysOriginal
        )

        button.setImage(image, for: .normal)

        return button
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .likeCircle).withRenderingMode(
            .alwaysOriginal
        )

        button.setImage(image, for: .normal)
        button.addTarget(
            self,
            action: #selector(likeButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    private let boostButton: UIButton = {
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

        heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

}

// MARK: - Actions

extension BottomControlsStackView {

    @objc func refreshButtonTapped(_ sender: UIButton) {
        delegate?.handleRefresh()
    }

    @objc func dislikeButtonTapped(_ sender: UIButton) {
        delegate?.handleDislike()
    }

    @objc func likeButtonTapped(_ sender: UIButton) {
        delegate?.handleLike()
    }

}

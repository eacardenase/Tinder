//
//  ProfileControls.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/17/25.
//

import UIKit

protocol ProfileControlsDelegate: AnyObject {

    func handleLike()
    func handleDislike()

}

class ProfileControls: UIStackView {

    // MARK: - Properties

    weak var delegate: ProfileControlsDelegate?

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

    private lazy var superLikeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .superLikeCircle).withRenderingMode(
            .alwaysOriginal
        )

        button.setImage(image, for: .normal)
        button.addTarget(
            self,
            action: #selector(superLikeButtonTapped),
            for: .touchUpInside
        )

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

extension ProfileControls {

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        distribution = .equalCentering
        spacing = 24

        [dislikeButton, superLikeButton, likeButton].forEach {
            addArrangedSubview($0)
        }
    }

}

// MARK: - Actions

extension ProfileControls {

    @objc func dislikeButtonTapped(_ sender: UIButton) {
        delegate?.handleDislike()
    }

    @objc func superLikeButtonTapped(_ sender: UIButton) {
        print(#function)
    }

    @objc func likeButtonTapped(_ sender: UIButton) {
        delegate?.handleLike()
    }

}

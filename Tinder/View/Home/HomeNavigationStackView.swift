//
//  HomeNavigationStackView.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/4/25.
//

import UIKit

protocol HomeNavigationStackViewDelegate: AnyObject {

    func showSettings()
    func showMessages()

}

class HomeNavigationStackView: UIStackView {

    // MARK: - Properties

    weak var delegate: HomeNavigationStackViewDelegate?

    lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .topLeftProfile).withRenderingMode(
            .alwaysOriginal
        )

        button.setImage(image, for: .normal)
        button.addTarget(
            self,
            action: #selector(settingButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    let tinderIcon: UIImageView = {
        let imageView = UIImageView()

        imageView.image = UIImage(resource: .appIcon)
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    lazy var messageButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .topRightMessages).withRenderingMode(
            .alwaysOriginal
        )

        button.setImage(image, for: .normal)
        button.addTarget(
            self,
            action: #selector(messageButtonTapped),
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

        heightAnchor.constraint(equalToConstant: 80).isActive = true
    }

}

// MARK: - Actions

extension HomeNavigationStackView {

    @objc func settingButtonTapped(_ sender: UIButton) {
        delegate?.showSettings()
    }

    @objc func messageButtonTapped(_ sender: UIButton) {
        delegate?.showMessages()
    }

}

//
//  MatchView.swift
//  Tinder
//
//  Created by Edwin Cardenas on 11/11/25.
//

import UIKit

class MatchView: UIView {

    // MARK: - Properties

    private let currentUser: User
    private let matchedUser: User

    private let visualEffectView = UIVisualEffectView(
        effect: UIBlurEffect(style: .dark)
    )

    private let matchImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .itsamatch))

        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0

        return label
    }()

    private let currentUserImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .jane1))

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor

        return imageView
    }()

    private let matcgedUserImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .kelly1))

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor

        return imageView
    }()

    private lazy var sendMessageButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(
            self,
            action: #selector(sendMessageButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var keepSwipingButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("KEEP SWIPING", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(
            self,
            action: #selector(keepSwipingButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    // MARK: - Initializers

    init(currentUser: User, matchedUser: User) {
        self.currentUser = currentUser
        self.matchedUser = matchedUser

        super.init(frame: .zero)

        configureBlurView()
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Helpers

extension MatchView {

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(matchImageView)
        addSubview(descriptionLabel)
        addSubview(currentUserImageView)
        addSubview(matchImageView)
        addSubview(sendMessageButton)
        addSubview(keepSwipingButton)
    }

    private func configureBlurView() {
        visualEffectView.alpha = 0
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(visualEffectView)

        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.visualEffectView.alpha = 1
        }.startAnimation()
    }

}

// MARK: - Actions

extension MatchView {

    @objc func sendMessageButtonTapped(_ sender: UIButton) {
        print(#function)
    }

    @objc func keepSwipingButtonTapped(_ sender: UIButton) {
        print(#function)
    }

}

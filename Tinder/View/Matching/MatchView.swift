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

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.text = "You and \(matchedUser.fullname) have liked each other!"

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

    private let matchedUserImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .kelly1))

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor

        return imageView
    }()

    private lazy var sendMessageButton: UIButton = {
        let button = SendMessageButton(type: .system)

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
        let button = KeepSwipingButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Keep Swiping", for: .normal)
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
        configureAnimations()

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissView)
        )

        addGestureRecognizer(tapGesture)
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
        addSubview(matchedUserImageView)
        addSubview(sendMessageButton)
        addSubview(keepSwipingButton)

        // matchImageView
        NSLayoutConstraint.activate([
            matchImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            matchImageView.bottomAnchor.constraint(
                equalTo: descriptionLabel.topAnchor,
                constant: -16
            ),
        ])

        // descriptionLabel
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            descriptionLabel.bottomAnchor.constraint(
                equalTo: currentUserImageView.topAnchor,
                constant: -32
            ),

        ])

        let currentUserImageHeightAnchor = currentUserImageView.heightAnchor
            .constraint(equalToConstant: 140)

        // currentUserImageView
        NSLayoutConstraint.activate([
            currentUserImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 48
            ),
            currentUserImageView.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),
            currentUserImageHeightAnchor,
            currentUserImageView.widthAnchor.constraint(
                equalToConstant: currentUserImageHeightAnchor.constant
            ),
        ])

        // matchedUserImageView
        NSLayoutConstraint.activate([
            matchedUserImageView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -48
            ),
            matchedUserImageView.centerYAnchor.constraint(
                equalTo: currentUserImageView.centerYAnchor
            ),
            matchedUserImageView.heightAnchor.constraint(
                equalToConstant: currentUserImageHeightAnchor.constant
            ),
            matchedUserImageView.widthAnchor.constraint(
                equalToConstant: currentUserImageHeightAnchor.constant
            ),
        ])

        currentUserImageView.layer.cornerRadius =
            currentUserImageHeightAnchor.constant / 2
        matchedUserImageView.layer.cornerRadius =
            currentUserImageHeightAnchor.constant / 2

        // sendMessageButton
        NSLayoutConstraint.activate([
            sendMessageButton.topAnchor.constraint(
                equalTo: currentUserImageView.bottomAnchor,
                constant: 32
            ),
            sendMessageButton.leadingAnchor.constraint(
                equalTo: currentUserImageView.leadingAnchor,
            ),
            sendMessageButton.trailingAnchor.constraint(
                equalTo: matchedUserImageView.trailingAnchor
            ),
        ])

        // keepSwipingButton
        NSLayoutConstraint.activate([
            keepSwipingButton.topAnchor.constraint(
                equalTo: sendMessageButton.bottomAnchor,
                constant: 16
            ),
            keepSwipingButton.leadingAnchor.constraint(
                equalTo: sendMessageButton.leadingAnchor
            ),
            keepSwipingButton.trailingAnchor.constraint(
                equalTo: sendMessageButton.trailingAnchor
            ),
        ])
    }

    private func configureBlurView() {
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(visualEffectView)

        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func configureAnimations() {
        let angle: CGFloat = 30 * .pi / 180

        currentUserImageView.transform = CGAffineTransform(
            rotationAngle: -angle
        ).concatenating(CGAffineTransform(translationX: 200, y: 0))

        matchedUserImageView.transform = CGAffineTransform(
            rotationAngle: angle
        ).concatenating(CGAffineTransform(translationX: -200, y: 0))

        sendMessageButton.transform = CGAffineTransform(translationX: 500, y: 0)
        keepSwipingButton.transform = CGAffineTransform(
            translationX: -500,
            y: 0
        )

        let animation = UIViewPropertyAnimator(duration: 1, curve: .easeInOut) {
            self.currentUserImageView.transform = .identity
            self.matchedUserImageView.transform = .identity
        }

        animation.addCompletion { _ in
            UIViewPropertyAnimator(duration: 1, dampingRatio: 0.8) {
                self.sendMessageButton.transform = .identity
                self.keepSwipingButton.transform = .identity
            }.startAnimation()
        }

        animation.startAnimation()
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

    @objc func dismissView(_ sender: UITapGestureRecognizer) {
        let animation = UIViewPropertyAnimator(
            duration: 0.5,
            curve: .easeInOut
        ) { self.alpha = 0 }

        animation.addCompletion { _ in
            self.removeFromSuperview()
        }

        animation.startAnimation()
    }

}

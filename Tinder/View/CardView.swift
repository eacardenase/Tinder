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

    let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()

        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.5, 1.1]

        return gradient
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
        configureGestureRecognizers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        gradientLayer.frame = frame
    }

}

// MARK: - Helpers

extension CardView {

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.cornerRadius = 8

        addSubview(imageView)

        layer.addSublayer(gradientLayer)

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
            infoButton.leadingAnchor.constraint(
                equalTo: infoLabel.trailingAnchor,
                constant: 8
            ),
            infoButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
        ])
    }

    private func configureGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePanGesture)
        )
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleChangePhoto)
        )

        addGestureRecognizer(panGesture)
        addGestureRecognizer(tapGesture)
    }

    private func panCard(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)

        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)

        self.transform = rotationalTransform.translatedBy(
            x: translation.x,
            y: translation.y
        )
    }

    private func resetCardPosition(sender: UIPanGestureRecognizer) {
        UIViewPropertyAnimator(duration: 0.75, dampingRatio: 0.7) {
            self.transform = .identity
        }.startAnimation()
    }

}

// MARK: - Actions

extension CardView {

    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {

        switch sender.state {
        case .began:
            print("DEBUG: Began")
        case .changed:
            panCard(sender: sender)
        case .ended:
            resetCardPosition(sender: sender)
        default: break
        }
    }

    @objc func handleChangePhoto(_ sender: UITapGestureRecognizer) {
        print(#function)
    }

}

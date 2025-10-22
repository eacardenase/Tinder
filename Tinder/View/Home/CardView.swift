//
//  CardView.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/6/25.
//

import SDWebImage
import UIKit

enum SwipeDirection: Int, Codable {
    case left = -1
    case right = 1
}

protocol CardViewDelegate: AnyObject {

    func cardView(_ view: CardView, wantsToShowProfileFor user: User)
    func cardView(_ view: CardView, didSwipeWith direction: SwipeDirection)

}

class CardView: UIView {

    // MARK: - Properties

    weak var delegate: CardViewDelegate?

    private(set) var viewModel: CardViewModel

    private lazy var imageView: UIImageView = {
        let _imageView = UIImageView()

        _imageView.translatesAutoresizingMaskIntoConstraints = false
        _imageView.contentMode = .scaleAspectFill
        _imageView.sd_setImage(with: viewModel.imageUrl)

        return _imageView
    }()

    let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()

        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.5, 1.1]

        return gradient
    }()

    private lazy var infoLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.attributedText = viewModel.userInfoText

        return label
    }()

    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .infoIcon).withRenderingMode(
            .alwaysOriginal
        )

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.addTarget(
            self,
            action: #selector(infoButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var barStackView = SegmentedBarView(
        numberOfSegments: viewModel.imageUrls.count
    )

    // MARK: - Initializers

    init(viewModel: CardViewModel) {
        self.viewModel = viewModel

        super.init(frame: .zero)

        setupViews()
        configureGestureRecognizers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func layoutSubviews() {
        gradientLayer.frame = frame
    }

}

// MARK: - Helpers

extension CardView {

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 8

        addSubview(imageView)
        addSubview(barStackView)

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

        // barStackView
        NSLayoutConstraint.activate([
            barStackView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 8
            ),
            barStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 8
            ),
            barStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -8
            ),
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
        let translation = sender.translation(in: nil)
        let swapThreshold: CGFloat = self.frame.width / 2

        let shouldDismissCard = abs(translation.x) > swapThreshold
        let direction: SwipeDirection =
            translation.x > swapThreshold ? .right : .left

        let animation = UIViewPropertyAnimator(
            duration: 0.75,
            dampingRatio: 0.7
        ) {
            if shouldDismissCard {
                let xTransalation =
                    CGFloat(direction.rawValue) * self.frame.width
                let offScreenTransform = self.transform.translatedBy(
                    x: xTransalation,
                    y: 0
                )

                self.transform = offScreenTransform

                return
            }

            self.transform = .identity
        }

        animation.startAnimation()

        animation.addCompletion { _ in
            if shouldDismissCard {
                self.delegate?.cardView(self, didSwipeWith: direction)
            }
        }
    }

}

// MARK: - Actions

extension CardView {

    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            superview?.subviews.forEach { $0.layer.removeAllAnimations() }
        case .changed:
            panCard(sender: sender)
        case .ended:
            resetCardPosition(sender: sender)
        default: break
        }
    }

    @objc func handleChangePhoto(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: nil).x
        let shouldShowNextPhoto = location > self.frame.width / 2

        if shouldShowNextPhoto {
            viewModel.prepareNextPhoto()
        } else {
            viewModel.preparePreviousPhoto()
        }

        imageView.sd_setImage(with: viewModel.imageUrl)

        barStackView.highlightSegment(at: viewModel.imageIndex)
    }

    @objc func infoButtonTapped(_ sender: UIButton) {
        delegate?.cardView(self, wantsToShowProfileFor: viewModel.user)
    }

}

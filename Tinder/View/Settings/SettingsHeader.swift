//
//  SettingsHeader.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/12/25.
//

import SDWebImage
import UIKit

protocol SettingsHeaderDelegate: AnyObject {

    func settingsHeader(_ header: SettingsHeader, didSelectButtonAt index: Int)

}

class SettingsHeader: UIStackView {

    // MARK: - Properties

    var viewModel: SettingsHeaderViewModel

    weak var delegate: SettingsHeaderDelegate?

    private lazy var button1 = createButton(withTag: 0)
    private lazy var button2 = createButton(withTag: 1)
    private lazy var button3 = createButton(withTag: 2)

    lazy var buttons = [
        button1, button2, button3,
    ]

    // MARK: - Initializers

    init(viewModel: SettingsHeaderViewModel) {
        self.viewModel = viewModel

        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 300))

        setupViews()
        loadUserPhotos()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Helpers

extension SettingsHeader {

    private func createButton(withTag tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        let imageConf = UIImage.SymbolConfiguration(pointSize: 40)
        let image = UIImage(
            systemName: "photo.badge.plus",
            withConfiguration: imageConf
        )?.withRenderingMode(.alwaysOriginal)

        button.setImage(image, for: .normal)
        button.tintColor = .lightGray
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.tag = tag
        button.addTarget(
            self,
            action: #selector(selectPhotoButtonTapped),
            for: .touchUpInside
        )

        return button
    }

    private func setupViews() {
        axis = .horizontal
        spacing = 16
        distribution = .fillEqually
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 16,
            leading: 16,
            bottom: 0,
            trailing: 16
        )

        let secondaryStackView = UIStackView(arrangedSubviews: [
            button2, button3,
        ])

        secondaryStackView.axis = .vertical
        secondaryStackView.spacing = 16
        secondaryStackView.distribution = .fillEqually

        addArrangedSubview(button1)
        addArrangedSubview(secondaryStackView)
    }

    private func loadUserPhotos() {
        for (index, imageURL) in viewModel.imageUrls.enumerated() {

            SDWebImageManager.shared.loadImage(with: imageURL, progress: nil) {
                [weak self] (image, _, _, _, _, _) in

                guard let self else { return }

                let button = self.buttons[index]

                button.setImage(
                    image?.withRenderingMode(.alwaysOriginal),
                    for: .normal
                )
            }
        }
    }

}

// MARK: - Actions

extension SettingsHeader {

    @objc func selectPhotoButtonTapped(_ sender: UIButton) {
        delegate?.settingsHeader(self, didSelectButtonAt: sender.tag)
    }

}

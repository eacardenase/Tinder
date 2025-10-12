//
//  SettingsHeader.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/12/25.
//

import UIKit

class SettingsHeader: UIView {

    // MARK: - Properties

    lazy var button1 = createButton()
    lazy var button2 = createButton()
    lazy var button3 = createButton()

    lazy var buttons = [
        button1, button2, button3,
    ]

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 300))

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers

extension SettingsHeader {

    private func createButton() -> UIButton {
        let button = UIButton(type: .system)

        button.setTitle("Select Photo", for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.addTarget(
            self,
            action: #selector(selectPhotoButtonTapped),
            for: .touchUpInside
        )

        return button
    }

    private func setupViews() {
        let primaryStackView = UIStackView()

        primaryStackView.translatesAutoresizingMaskIntoConstraints = false
        primaryStackView.axis = .horizontal
        primaryStackView.spacing = 16
        primaryStackView.distribution = .fillEqually
        primaryStackView.isLayoutMarginsRelativeArrangement = true
        primaryStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 16,
            leading: 16,
            bottom: 16,
            trailing: 16
        )

        let secondaryStackView = UIStackView(arrangedSubviews: [
            button2, button3,
        ])

        secondaryStackView.axis = .vertical
        secondaryStackView.spacing = 16
        secondaryStackView.distribution = .fillEqually

        primaryStackView.addArrangedSubview(button1)
        primaryStackView.addArrangedSubview(secondaryStackView)

        addSubview(primaryStackView)

        // primaryStackView
        NSLayoutConstraint.activate([
            primaryStackView.topAnchor.constraint(equalTo: topAnchor),
            primaryStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            primaryStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            primaryStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

    }

}

// MARK: - Actions

extension SettingsHeader {

    @objc func selectPhotoButtonTapped(_ sender: UIButton) {
        print(#function)
    }

}

//
//  SettingsFooter.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/16/25.
//

import UIKit

protocol SettingsFooterDelegate: AnyObject {

    func handleLogout()

}

class SettingsFooter: UIView {

    // MARK: - Properties

    weak var delegate: SettingsFooterDelegate?

    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log out", for: .normal)
        button.setTitleColor(.systemPink, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemPink.cgColor
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.addTarget(
            self,
            action: #selector(logoutButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 100))

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Helpers

extension SettingsFooter {

    private func setupViews() {
        addSubview(logoutButton)

        NSLayoutConstraint.activate([
            logoutButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoutButton.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 32
            ),
            logoutButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -32
            ),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

}

// MARK: - Actions

extension SettingsFooter {

    @objc func logoutButtonTapped(_ sender: UIButton) {
        delegate?.handleLogout()
    }

}

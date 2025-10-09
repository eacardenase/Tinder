//
//  LoginController.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/8/25.
//

import UIKit

class LoginController: UIViewController {

    // MARK: - Properties

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(resource: .appIcon).withRenderingMode(
            .alwaysTemplate
        )

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.tintColor = .white

        return imageView
    }()

    private let emailTextField = AuthTextField(placeholder: "Email")
    private let passwordTextField = AuthTextField(
        placeholder: "Password",
        isSecure: true
    )

    private lazy var loginButton: UIButton = {
        let button = AuthButton(withTitle: "Log In")

        button.addTarget(
            self,
            action: #selector(loginButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var showRegistrationButton: UIButton = {
        let button = AttributedAuthButton(
            message: "Don't have an account? ",
            actionText: "Sign Up",
        )

        button.addTarget(
            self,
            action: #selector(showRegistrationButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureGradientLayer()
        setupViews()
    }
}

// MARK: - Helpers

extension LoginController {

    private func setupViews() {
        navigationController?.navigationBar.isHidden = true

        let stackView = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            loginButton,
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16

        view.addSubview(iconImageView)
        view.addSubview(stackView)
        view.addSubview(showRegistrationButton)

        // iconImageView
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 32
            ),
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 100),
            iconImageView.heightAnchor.constraint(
                equalTo: iconImageView.widthAnchor
            ),
        ])

        // stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: iconImageView.bottomAnchor,
                constant: 24
            ),
            stackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 32
            ),
            stackView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -32
            ),
        ])

        // showRegistrationButton
        NSLayoutConstraint.activate([
            showRegistrationButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            showRegistrationButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -8
            ),
        ])
    }

}

// MARK: - Actions

extension LoginController {

    @objc func loginButtonTapped(_ sender: UIButton) {
        print(#function)
    }

    @objc func showRegistrationButtonTapped(_ sender: UIButton) {
        let controller = RegistrationController()

        navigationController?.pushViewController(controller, animated: true)
    }

}

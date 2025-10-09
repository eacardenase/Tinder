//
//  RegistrationController.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/8/25.
//

import UIKit

class RegistrationController: UIViewController {

    // MARK: - Properties

    private lazy var addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConf = UIImage.SymbolConfiguration(pointSize: 100)
        let buttonImage = UIImage(
            systemName: "photo.badge.plus",
            withConfiguration: imageConf
        )

        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setImage(buttonImage, for: .normal)
        button.addTarget(
            self,
            action: #selector(addPhotoButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    private let fullnameTextField = AuthTextField(placeholder: "Full Name")
    private let emailTextField = AuthTextField(placeholder: "Email")
    private let passwordTextField = AuthTextField(
        placeholder: "Password",
        isSecure: true
    )

    private lazy var showLoginButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(
            string: "Already have an account? ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.white,
            ]
        )

        attributedTitle.append(
            NSAttributedString(
                string: "Sign In",
                attributes: [
                    .font: UIFont.boldSystemFont(ofSize: 16),
                    .foregroundColor: UIColor.white,
                ]
            )
        )

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(
            self,
            action: #selector(showLoginButtonTapped),
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

    private lazy var signUpButton: UIButton = {
        let button = AuthButton(withTitle: "Sign Up")

        button.addTarget(
            self,
            action: #selector(signUpButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

}

// MARK: - Helpers

extension RegistrationController {

    private func setupViews() {
        navigationController?.navigationBar.isHidden = true

        let stackView = UIStackView(arrangedSubviews: [
            fullnameTextField, emailTextField, passwordTextField, signUpButton,
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16

        view.addSubview(addPhotoButton)
        view.addSubview(stackView)
        view.addSubview(showLoginButton)

        // addPhotoButton
        NSLayoutConstraint.activate([
            addPhotoButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 8
            ),
            addPhotoButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 275),
            addPhotoButton.widthAnchor.constraint(
                equalTo: addPhotoButton.heightAnchor
            ),
        ])

        // stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: addPhotoButton.bottomAnchor,
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

        // showLoginButton
        NSLayoutConstraint.activate([
            showLoginButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            showLoginButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -8
            ),
        ])
    }

}

// MARK: - Actions

extension RegistrationController {

    @objc func addPhotoButtonTapped(_ sender: UIButton) {
        print(#function)
    }

    @objc func signUpButtonTapped(_ sender: UIButton) {
        print(#function)
    }

    @objc func showLoginButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}

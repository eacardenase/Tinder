//
//  LoginController.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/8/25.
//

import UIKit

class LoginController: UIViewController {

    // MARK: - Properties

    private var viewModel = LoginViewModel()
    weak var delegate: AuthenticationDelegate?

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

    private lazy var emailTextField: UITextField = {
        let textField = AuthTextField(placeholder: "Email")

        textField.keyboardType = .emailAddress
        textField.addTarget(
            self,
            action: #selector(textDidChange),
            for: .editingChanged
        )

        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = AuthTextField(placeholder: "Password", isSecure: true)

        textField.addTarget(
            self,
            action: #selector(textDidChange),
            for: .editingChanged
        )

        return textField
    }()

    private lazy var loginButton: UIButton = {
        let button = AuthButton(type: .system)

        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)

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

    @objc func textDidChange(_ sender: UITextField) {
        if sender === emailTextField {
            viewModel.email = sender.text
        } else if sender === passwordTextField {
            viewModel.password = sender.text
        }

        updateForm()
    }

    @objc func loginButtonTapped(_ sender: UIButton) {
        guard
            let email = viewModel.email,
            let password = viewModel.password
        else {
            return
        }

        AuthService.logUserIn(withEmail: email, password: password) { error in
            if let error {
                let alertController = UIAlertController(
                    title: "Error",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )

                alertController.addAction(
                    UIAlertAction(title: "OK", style: .default)
                )

                self.present(alertController, animated: true)

                return
            }

            self.delegate?.authenticationComplete()
        }
    }

    @objc func showRegistrationButtonTapped(_ sender: UIButton) {
        let controller = RegistrationController()
        controller.delegate = delegate

        navigationController?.pushViewController(controller, animated: true)
    }

}

// MARK: - AuthenticationControllerProtocol

extension LoginController: AuthenticationProtocol {

    func updateForm() {
        loginButton.isEnabled = viewModel.shouldEnableButton
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
    }

}

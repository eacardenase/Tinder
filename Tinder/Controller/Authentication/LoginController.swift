//
//  LoginController.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/8/25.
//

import GoogleSignIn
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

    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()

        let attributedTitle = NSMutableAttributedString(
            string: "Forgot your password? ",
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.87),
                .font: UIFont.boldSystemFont(ofSize: 15),
            ]
        )

        attributedTitle.append(
            NSAttributedString(
                string: "Get help signing in.",
                attributes: [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.boldSystemFont(ofSize: 15),
                ]
            )
        )

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(
            self,
            action: #selector(showPasswordResetController),
            for: .touchUpInside
        )

        return button
    }()

    private let dividerView = DividerView()

    private lazy var googleLoginButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(
            UIImage(resource: .btnGoogleLightPressedIos).withRenderingMode(
                .alwaysOriginal
            ),
            for: .normal
        )
        button.setTitle("  Log in with Google", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(
            self,
            action: #selector(googleLoginButtonTapped),
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

        let secondStack = UIStackView(arrangedSubviews: [
            forgotPasswordButton,
            dividerView,
            googleLoginButton,
        ])

        secondStack.translatesAutoresizingMaskIntoConstraints = false
        secondStack.axis = .vertical
        secondStack.spacing = 28

        view.addSubview(iconImageView)
        view.addSubview(stackView)
        view.addSubview(secondStack)
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

        // secondStack
        NSLayoutConstraint.activate([
            secondStack.topAnchor.constraint(
                equalTo: stackView.bottomAnchor,
                constant: 24
            ),
            secondStack.leadingAnchor.constraint(
                equalTo: stackView.leadingAnchor
            ),
            secondStack.trailingAnchor.constraint(
                equalTo: stackView.trailingAnchor
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

        showLoader()

        AuthService.logUserIn(withEmail: email, password: password) {
            [weak self] error in

            guard let self else { return }

            self.showLoader(false)

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

    @objc private func showPasswordResetController(_ sender: UIButton) {
        let resetPasswordController = ResetPasswordController()

        resetPasswordController.email = emailTextField.text
        resetPasswordController.delegate = self

        navigationController?.pushViewController(
            resetPasswordController,
            animated: true
        )
    }

    @objc func showRegistrationButtonTapped(_ sender: UIButton) {
        let controller = RegistrationController()
        controller.delegate = delegate

        navigationController?.pushViewController(controller, animated: true)
    }

    @objc func googleLoginButtonTapped(_ sender: UIButton) {
        showLoader()

        AuthService.signInWithGoogle(withPresenting: self) {
            [weak self] result in

            guard let self else { return }

            self.showLoader(false)

            switch result {
            case .success(let user):
                self.delegate?.authenticationComplete()
            case .failure(let error):
                if case .serverError(let message) = error {
                    let alertController = UIAlertController(
                        title: "Error",
                        message: message,
                        preferredStyle: .alert
                    )

                    alertController.addAction(
                        UIAlertAction(title: "OK", style: .default)
                    )

                    self.present(alertController, animated: true)
                }
            }
        }
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

// MARK: - ResetPasswordControllerDelegate

extension LoginController: ResetPasswordControllerDelegate {

    func didSendResetPasswordLink() {
        navigationController?.popViewController(animated: true)

        let alertController = UIAlertController(
            title: "Success",
            message: "We sent a link to your email to reset your password",
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(title: "OK", style: .default))

        present(alertController, animated: true)
    }

}

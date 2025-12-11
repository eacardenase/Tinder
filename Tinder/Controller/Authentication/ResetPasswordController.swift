//
//  ResetPasswordController.swift
//  Tinder
//
//  Created by Edwin Cardenas on 12/10/25.
//

import UIKit

protocol ResetPasswordControllerDelegate: AnyObject {

    func didSendResetPasswordLink()

}

class ResetPasswordController: UIViewController {

    // MARK: - Properties

    var viewModel = ResetPasswordViewModel()
    weak var delegate: ResetPasswordControllerDelegate?
    var email: String? {
        didSet {
            viewModel.email = email

            updateForm()
        }
    }

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.addTarget(
            self,
            action: #selector(handleDismissal),
            for: .touchUpInside
        )

        return button
    }()

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
        textField.text = email
        textField.autocapitalizationType = .none
        textField.addTarget(
            self,
            action: #selector(textFieldEditingChanged),
            for: .editingChanged
        )

        return textField
    }()

    private lazy var resetPasswordButton: AuthButton = {
        let button = AuthButton(type: .system)

        button.setTitle("Send Reset Link", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.addTarget(
            self,
            action: #selector(handlePasswordReset),
            for: .touchUpInside
        )

        return button
    }()

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )

        view.addGestureRecognizer(tapGesture)
    }

}

// MARK: Helpers

extension ResetPasswordController {

    private func setupViews() {
        configureGradientLayer()

        let stackView = UIStackView(arrangedSubviews: [
            emailTextField,
            resetPasswordButton,
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16

        view.addSubview(backButton)
        view.addSubview(iconImageView)
        view.addSubview(stackView)

        // backButton
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            backButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
        ])

        // iconImageView
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 100),
            iconImageView.widthAnchor.constraint(
                equalTo: iconImageView.heightAnchor
            ),
            iconImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 32
            ),
        ])

        // stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: iconImageView.bottomAnchor,
                constant: 32
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
    }

}

// MARK: - Actions

extension ResetPasswordController {

    @objc private func handleDismissal(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @objc private func handlePasswordReset(_ sender: UIButton) {
        guard let email = viewModel.email else {
            return
        }

        showLoader()

        AuthService.resetPassword(withEmail: email) { [weak self] error in
            guard let self else { return }

            self.showLoader(false)

            if let error {
                let alertController = UIAlertController(
                    title: "Success",
                    message:
                        "We sent a link to your email to reset your password",
                    preferredStyle: .alert
                )

                alertController.addAction(
                    UIAlertAction(title: "OK", style: .default)
                )

                self.present(alertController, animated: true)

                return
            }

            self.delegate?.didSendResetPasswordLink()
        }
    }

    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc private func textFieldEditingChanged(_ sender: UITextField) {
        viewModel.email = sender.text

        updateForm()
    }

}
//
// MARK: - FormViewModel

extension ResetPasswordController: AuthenticationProtocol {

    func updateForm() {
        resetPasswordButton.isEnabled = viewModel.shouldEnableButton
        resetPasswordButton.backgroundColor = viewModel.buttonBackgroundColor
        resetPasswordButton.setTitleColor(
            viewModel.buttonTitleColor,
            for: .normal
        )
    }

}

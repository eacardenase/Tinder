//
//  RegistrationController.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/8/25.
//

import UIKit

class RegistrationController: UIViewController {

    // MARK: - Properties

    var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?

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
        button.clipsToBounds = true
        button.addTarget(
            self,
            action: #selector(addPhotoButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var fullnameTextField: UITextField = {
        let textField = AuthTextField(placeholder: "Full Name")

        textField.autocapitalizationType = .words
        textField.addTarget(
            self,
            action: #selector(textDidChange),
            for: .editingChanged
        )

        return textField
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

    private lazy var showLoginButton: UIButton = {
        let button = AttributedAuthButton(
            message: "Already have an account?",
            actionText: "Sign In"
        )

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

    @objc func textDidChange(_ sender: UITextField) {
        if sender === fullnameTextField {
            viewModel.fullname = fullnameTextField.text
        } else if sender === emailTextField {
            viewModel.email = emailTextField.text?.lowercased()
        } else {
            viewModel.password = passwordTextField.text
        }

        updateForm()
    }

    @objc func addPhotoButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()

        imagePicker.delegate = self

        present(imagePicker, animated: true)
    }

    @objc func signUpButtonTapped(_ sender: UIButton) {
        guard
            let fullname = viewModel.fullname,
            let email = viewModel.email,
            let password = viewModel.password
        else {
            return
        }

        guard let profileImage else {
            let alertController = UIAlertController(
                title: "Profile Photo",
                message: "Please provide an image to be used as profile photo.",
                preferredStyle: .alert
            )

            alertController.addAction(
                UIAlertAction(title: "OK", style: .default)
            )

            present(alertController, animated: true)

            return
        }

        let credentials = AuthCredentials(
            fullname: fullname,
            email: email,
            password: password,
            profileImage: profileImage
        )

        AuthService.createUser(wih: credentials) { result in
            switch result {
            case .success:
                self.dismiss(animated: true)
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

    @objc func showLoginButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:
            Any]
    ) {
        let image = info[.originalImage] as? UIImage

        profileImage = image

        addPhotoButton.imageView?.contentMode = .scaleAspectFill
        addPhotoButton.layer.cornerRadius = 16
        addPhotoButton.layer.borderWidth = 1.5
        addPhotoButton.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        addPhotoButton.setImage(
            image?.withRenderingMode(.alwaysOriginal),
            for: .normal
        )

        dismiss(animated: true)
    }

}

// MARK: - AuthenticationProtocol

extension RegistrationController: AuthenticationProtocol {

    func updateForm() {
        signUpButton.isEnabled = viewModel.shouldEnableButton
        signUpButton.backgroundColor = viewModel.buttonBackgroundColor
        signUpButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
    }

}

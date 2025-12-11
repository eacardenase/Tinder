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

    private lazy var googleLoginButton: UIButton = {
        let button = AuthButton(type: .system)

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

        view.addSubview(iconImageView)
        view.addSubview(googleLoginButton)

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

        // googleLoginButton
        NSLayoutConstraint.activate([
            googleLoginButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 32
            ),
            googleLoginButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -32
            ),
            googleLoginButton.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),
        ])
    }

}

// MARK: - Actions

extension LoginController {

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

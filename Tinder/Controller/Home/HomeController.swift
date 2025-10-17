//
//  HomeController.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/4/25.
//

import UIKit

class HomeController: UIViewController {

    // MARK: - Properties

    private var user: User?

    private lazy var topStack: HomeNavigationStackView = {
        let stackView = HomeNavigationStackView()

        stackView.delegate = self

        return stackView
    }()

    var viewModels = [CardViewModel]() {
        didSet { configureCards() }
    }

    private let deckView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 8

        return view
    }()

    private let bottomStack = BottomControlsStackView()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        authenticateUser()
        setupViews()
        fetchUsers()
    }

}

// MARK: - Helpers

extension HomeController {

    private func configureCards() {
        viewModels.forEach { viewModel in
            let cardView = CardView(viewModel: viewModel)

            deckView.addSubview(cardView)

            // cardView
            NSLayoutConstraint.activate([
                cardView.topAnchor.constraint(equalTo: deckView.topAnchor),
                cardView.leadingAnchor.constraint(
                    equalTo: deckView.leadingAnchor
                ),
                cardView.trailingAnchor.constraint(
                    equalTo: deckView.trailingAnchor
                ),
                cardView.bottomAnchor.constraint(
                    equalTo: deckView.bottomAnchor
                ),
            ])
        }
    }

    private func setupViews() {
        view.backgroundColor = .white

        let stackView = UIStackView(arrangedSubviews: [
            topStack, deckView, bottomStack,
        ])

        stackView.bringSubviewToFront(deckView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: 12,
            bottom: 0,
            trailing: 12
        )

        view.addSubview(stackView)

        // stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            stackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            stackView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
            stackView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
        ])
    }

    private func presentLoginController() {
        DispatchQueue.main.async {
            let loginController = LoginController()
            let navController = UINavigationController(
                rootViewController: loginController
            )

            navController.modalPresentationStyle = .fullScreen

            self.present(navController, animated: true)
        }
    }

}

// MARK: - API

extension HomeController {

    func authenticateUser() {
        AuthService.verifyLogin { result in
            switch result {
            case .success(let user):
                self.user = user
            case .failure(let error):
                print("DEBUG: \(error.localizedDescription)")

                self.presentLoginController()
            }
        }
    }

    func logout() {
        showLoader()

        AuthService.logUserOut { error in
            self.showLoader(false)

            if let error {
                print(
                    "DEBUG: Failed to log out with error: \(error.localizedDescription)"
                )
            }

            self.presentLoginController()
        }
    }

    func fetchUsers() {
        UserService.fetchUsers { result in
            switch result {
            case .success(let users):
                self.viewModels = users.map { CardViewModel(user: $0) }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

// MARK: - HomeNavigationStackViewDelegate

extension HomeController: HomeNavigationStackViewDelegate {

    func showSettings() {
        guard let user else { return }

        let controller = SettingsController(user: user)
        controller.delegate = self

        let navController = UINavigationController(
            rootViewController: controller
        )

        navController.modalPresentationStyle = .fullScreen

        present(navController, animated: true)
    }

    func showMessages() {
        print(#function)
    }

}

// MARK: - SettingsControllerDelegate

extension HomeController: SettingsControllerDelegate {

    func settingsController(
        _ controller: SettingsController,
        wantsToUpdate user: User
    ) {
        self.showLoader()

        controller.dismiss(animated: true) {
            self.user = user

            UserService.store(user) { result in
                self.showLoader(false)

                if case .failure(let error) = result {
                    print(
                        "DEBUG: Failed to update user with error: \(error.localizedDescription)"
                    )
                }
            }
        }
    }

    func handleLogout() {
        logout()
    }

}

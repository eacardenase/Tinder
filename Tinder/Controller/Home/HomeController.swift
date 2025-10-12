//
//  HomeController.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/4/25.
//

import UIKit

class HomeController: UIViewController {

    // MARK: - Properties

    private let topStack = HomeNavigationStackView()

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
        configureCards()
        // logout()
        fetchUsers()
    }

}

// MARK: - Helpers

extension HomeController {

    private func configureCards() {
        print(#function)
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
        AuthService.verifyLogin { error in
            if case .serverError(let message) = error {
                print("DEBUG: \(message)")

                self.presentLoginController()
            }
        }
    }

    func logout() {
        AuthService.logUserOut { error in
            if let error {
                print("DEBUG: \(error.localizedDescription)")

                return
            }

            self.presentLoginController()
        }
    }

    func fetchUser() {
        guard let userId = AuthService.currentUser?.uid else { return }

        UserService.fetchUser(withId: userId) { result in
            switch result {
            case .success(let user):
                print(user.fullname)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func fetchUsers() {
        UserService.fetchUsers { result in
            switch result {
            case .success(let users):
                print(users)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

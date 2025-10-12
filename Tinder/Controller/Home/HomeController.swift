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
        fetchUser()
    }

}

// MARK: - Helpers

extension HomeController {

    private func configureCards() {
        //        let user1 = User(
        //            name: "Jane Doe",
        //            age: 21,
        //            images: [
        //                UIImage(resource: .jane1),
        //                UIImage(resource: .jane2),
        //                UIImage(resource: .jane3),
        //            ]
        //        )
        //        let user2 = User(
        //            name: "Megan",
        //            age: 24,
        //            images: [
        //                UIImage(resource: .kelly1),
        //                UIImage(resource: .kelly2),
        //                UIImage(resource: .kelly3),
        //            ]
        //        )

        //        let cardView1 = CardView(viewModel: CardViewModel(user: user1))
        //        let cardView2 = CardView(viewModel: CardViewModel(user: user2))
        //
        //        deckView.addSubview(cardView1)
        //        deckView.addSubview(cardView2)
        //
        //        // cardView1
        //        NSLayoutConstraint.activate([
        //            cardView1.topAnchor.constraint(equalTo: deckView.topAnchor),
        //            cardView1.leadingAnchor.constraint(equalTo: deckView.leadingAnchor),
        //            cardView1.trailingAnchor.constraint(
        //                equalTo: deckView.trailingAnchor
        //            ),
        //            cardView1.bottomAnchor.constraint(equalTo: deckView.bottomAnchor),
        //        ])
        //
        //        // cardView2
        //        NSLayoutConstraint.activate([
        //            cardView2.topAnchor.constraint(equalTo: deckView.topAnchor),
        //            cardView2.leadingAnchor.constraint(equalTo: deckView.leadingAnchor),
        //            cardView2.trailingAnchor.constraint(
        //                equalTo: deckView.trailingAnchor
        //            ),
        //            cardView2.bottomAnchor.constraint(equalTo: deckView.bottomAnchor),
        //        ])
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

}

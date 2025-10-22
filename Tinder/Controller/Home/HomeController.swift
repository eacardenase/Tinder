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
    private var cardViews = [CardView]()
    private var previousCard: CardView?
    private var topCardView: CardView? {
        return cardViews.last
    }

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
        view.layer.cornerRadius = 8

        return view
    }()

    private lazy var bottomStack: BottomControlsStackView = {
        let stackView = BottomControlsStackView()

        stackView.delegate = self

        return stackView
    }()

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
            cardView.delegate = self

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

            cardViews.append(cardView)
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

    private func performSwipe(withDirection direction: SwipeDirection) {
        guard let topCard = topCardView else { return }

        previousCard = cardViews.popLast()

        let nextCard = cardViews.last

        nextCard?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        nextCard?.alpha = 0.5

        let directionValue = CGFloat(direction.rawValue)
        let angle: CGFloat = (.pi / 6) * directionValue
        let xTranslation: CGFloat = topCard.frame.width * directionValue

        let transform = CGAffineTransform(translationX: xTranslation, y: 0)
            .rotated(by: angle)

        SwipeService.saveSwipe(for: topCard.viewModel.user, with: direction) {
            error in

            if let error {
                print(
                    "DEBUG: Failed to save swipe with error: \(error.localizedDescription)"
                )
            }

            let animation = UIViewPropertyAnimator(
                duration: 0.3,
                curve: .easeIn
            ) {
                topCard.transform = transform

                nextCard?.transform = .identity
                nextCard?.alpha = 1.0
            }

            animation.startAnimation()

            animation.addCompletion { _ in
                topCard.removeFromSuperview()
            }
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

// MARK: - CardViewDelegate

extension HomeController: CardViewDelegate {

    func cardView(_ view: CardView, didSwipeWith direction: SwipeDirection) {
        guard let topCard = topCardView else { return }

        SwipeService.saveSwipe(for: topCard.viewModel.user, with: direction) {
            error in
            if let error {
                print(
                    "DEBUG: Failed to save swipe with error: \(error.localizedDescription)"
                )

                return
            }

            view.removeFromSuperview()

            self.previousCard = self.cardViews.popLast()
        }
    }

    func cardView(_ view: CardView, wantsToShowProfileFor user: User) {
        let controller = ProfileController(
            viewModel: ProfileViewModel(user: user)
        )

        controller.modalPresentationStyle = .fullScreen

        present(controller, animated: true)
    }

}

// MARK: - BottomControlsStackViewDelegate

extension HomeController: BottomControlsStackViewDelegate {

    func handleRefresh() {
        // guard let previousCard else { return }

        // print("DEBUG: Put back user \(previousCard.viewModel.user.fullname)")

        // cardViews.append(previousCard)
    }

    func handleDislike() {
        performSwipe(withDirection: .left)
    }

    func handleLike() {
        performSwipe(withDirection: .right)
    }

}

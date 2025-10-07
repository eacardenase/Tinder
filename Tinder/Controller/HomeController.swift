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

        setupViews()
        configureCards()
    }

}

// MARK: - Helpers

extension HomeController {

    private func configureCards() {
        let cardView1 = CardView()
        let cardView2 = CardView()

        deckView.addSubview(cardView1)
        deckView.addSubview(cardView2)

        // cardView1
        NSLayoutConstraint.activate([
            cardView1.topAnchor.constraint(equalTo: deckView.topAnchor),
            cardView1.leadingAnchor.constraint(equalTo: deckView.leadingAnchor),
            cardView1.trailingAnchor.constraint(
                equalTo: deckView.trailingAnchor
            ),
            cardView1.bottomAnchor.constraint(equalTo: deckView.bottomAnchor),
        ])

        // cardView2
        NSLayoutConstraint.activate([
            cardView2.topAnchor.constraint(equalTo: deckView.topAnchor),
            cardView2.leadingAnchor.constraint(equalTo: deckView.leadingAnchor),
            cardView2.trailingAnchor.constraint(
                equalTo: deckView.trailingAnchor
            ),
            cardView2.bottomAnchor.constraint(equalTo: deckView.bottomAnchor),
        ])
    }

    private func setupViews() {
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

}

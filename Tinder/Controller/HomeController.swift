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

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

}

// MARK: - Helpers

extension HomeController {

    private func setupViews() {
        view.addSubview(topStack)

        // navigationStack
        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            topStack.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            topStack.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
        ])
    }

}

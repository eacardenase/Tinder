//
//  ProfileController.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/17/25.
//

import UIKit

class ProfileController: UIViewController {

    // MARK: - Properties

    let user: User

    // MARK: - Initializers

    init(user: User) {
        self.user = user

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

}

// MARK: - Helpers

extension ProfileController {

    private func setupViews() {
        view.backgroundColor = .systemPink
    }

}

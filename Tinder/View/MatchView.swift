//
//  MatchView.swift
//  Tinder
//
//  Created by Edwin Cardenas on 11/11/25.
//

import UIKit

class MatchView: UIView {

    private let currentUser: User
    private let matchedUser: User

    init(currentUser: User, matchedUser: User) {
        self.currentUser = currentUser
        self.matchedUser = matchedUser

        super.init(frame: .zero)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Helpers

extension MatchView {

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemRed
    }

}

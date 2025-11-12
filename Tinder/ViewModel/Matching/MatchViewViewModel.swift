//
//  MatchViewViewModel.swift
//  Tinder
//
//  Created by Edwin Cardenas on 11/12/25.
//

import Foundation

struct MatchViewViewModel {

    // MARK: - Properties

    private let currentUser: User
    let matchedUser: User

    var matchLabelText: String {
        return "You and \(matchedUser.fullname) have liked each other!"
    }

    var currentUserImageURL: URL? {
        guard let imageUrl = currentUser.imageUrls.first else { return nil }

        return URL(string: imageUrl)
    }

    var matchedUserImageURL: URL? {
        guard let imageUrls = matchedUser.imageUrls.first else { return nil }

        return URL(string: imageUrls)
    }

    // MARK: - Initializers

    init(currentUser: User, matchedUser: User) {
        self.currentUser = currentUser
        self.matchedUser = matchedUser
    }

}

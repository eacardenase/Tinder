//
//  MatchCellViewModel.swift
//  Tinder
//
//  Created by Edwin Cardenas on 11/14/25.
//

import Foundation

struct MatchCellViewModel {

    // MARK: - Properties

    private let match: Match

    var userUid: String {
        return match.profileUid
    }

    var nameText: String {
        return match.name
    }

    var profileImageUrl: URL? {
        return URL(string: match.profileImageUrl)
    }

    var shouldShowBubble: Bool {
        return !match.isNew
    }

    // MARK: - Initializers

    init(match: Match) {
        self.match = match
    }

}

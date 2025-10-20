//
//  ProfileViewModel.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/19/25.
//

import UIKit

struct ProfileViewModel {

    // MARK: - Properties

    private let user: User

    var imageCount: Int {
        return user.imageUrls.count
    }

    var imageUrls: [URL?] {
        return user.imageUrls.map { URL(string: $0) }
    }

    var userDetailsAttributedString: NSAttributedString {
        let attributedText = NSMutableAttributedString(
            string: user.fullname,
            attributes: [
                .font: UIFont.systemFont(ofSize: 24, weight: .semibold)
            ]
        )

        attributedText.append(
            NSAttributedString(
                string: "  \(user.age)",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 22)
                ]
            )
        )

        return attributedText
    }

    var profesion: String? {
        return user.profession
    }

    var bio: String? {
        return user.bio
    }

    // MARK: - Initializers

    init(user: User) {
        self.user = user
    }

}

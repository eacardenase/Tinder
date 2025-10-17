//
//  CardViewModel.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/7/25.
//

import UIKit

struct CardViewModel {

    // MARK: - Properties

    private let user: User

    var userInfoText: NSAttributedString {
        let attributedText = NSMutableAttributedString(
            string: user.fullname,
            attributes: [
                .font: UIFont.systemFont(ofSize: 32, weight: .heavy),
                .foregroundColor: UIColor.white,
            ]
        )

        attributedText.append(
            NSAttributedString(
                string: "  \(user.age)",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 24),
                    .foregroundColor: UIColor.white,
                ]
            )
        )

        return attributedText
    }

    private(set) var imageIndex = 0

    var imageUrl: URL? {
        return URL(string: user.imageUrls[imageIndex])
    }

    var imageUrls: [String] {
        return user.imageUrls
    }

    // MARK: - Initializers

    init(user: User) {
        self.user = user
    }

}

// MARK: - Helpers

extension CardViewModel {

    mutating func prepareNextPhoto() {
        guard imageIndex < user.imageUrls.count - 1 else { return }

        imageIndex += 1
    }

    mutating func preparePreviousPhoto() {
        guard imageIndex > 0 else { return }

        imageIndex -= 1
    }

}

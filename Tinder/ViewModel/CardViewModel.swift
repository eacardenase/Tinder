//
//  CardViewModel.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/7/25.
//

import UIKit

struct CardViewModel {

    // MARK: - Properties

    let user: User

    var userInfoText: NSAttributedString {
        let attributedText = NSMutableAttributedString(
            string: user.name,
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

    private var imageIndex = 0 {
        didSet {
            profileImage = user.images[imageIndex]
        }
    }

    lazy var profileImage = user.images.first

    // MARK: - Initializers

    init(user: User) {
        self.user = user
    }

}

// MARK: - Helpers

extension CardViewModel {

    mutating func prepareNextPhoto() {
        guard imageIndex < user.images.count - 1 else { return }

        imageIndex += 1
    }

    mutating func preparePreviousPhoto() {
        guard imageIndex > 0 else { return }

        imageIndex -= 1
    }

}

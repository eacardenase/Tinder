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

    // MARK: - Initializers

    init(user: User) {
        self.user = user
    }

}

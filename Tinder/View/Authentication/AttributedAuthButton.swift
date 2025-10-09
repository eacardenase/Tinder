//
//  AttributedAuthButton.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/9/25.
//

import UIKit

class AttributedAuthButton: UIButton {

    // MARK: - Initializers

    init(message: String, actionText: String) {
        super.init(frame: .zero)

        let attributedTitle = NSMutableAttributedString(
            string: message,
            attributes: [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.white,
            ]
        )

        attributedTitle.append(
            NSAttributedString(
                string: " \(actionText)",
                attributes: [
                    .font: UIFont.boldSystemFont(ofSize: 16),
                    .foregroundColor: UIColor.white,
                ]
            )
        )

        translatesAutoresizingMaskIntoConstraints = false
        setAttributedTitle(attributedTitle, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

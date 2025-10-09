//
//  AuthButton.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/8/25.
//

import UIKit

class AuthButton: UIButton {

    // MARK: - Initializers

    init(withTitle title: String) {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        isEnabled = false
        setTitle(title, for: .normal)
        setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        backgroundColor = .white.withAlphaComponent(0.2)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 50)
    }

}

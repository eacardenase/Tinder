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
        isEnabled = false
        setTitle(title, for: .normal)
        setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        backgroundColor = UIColor(red: 0.9, green: 0.47, blue: 0.64, alpha: 1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 50)
    }

}

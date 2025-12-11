//
//  AuthButton.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/8/25.
//

import UIKit

class AuthButton: UIButton {

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        setTitleColor(.white, for: .normal)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 50)
    }

}

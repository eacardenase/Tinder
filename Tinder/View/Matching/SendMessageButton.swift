//
//  SendMessageButton.swift
//  Tinder
//
//  Created by Edwin Cardenas on 11/11/25.
//

import UIKit

class SendMessageButton: UIButton {

    // MARK: - Properties

    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()

        let leftColor = UIColor(red: 0.99, green: 0.35, blue: 0.37, alpha: 1)
        let rightColor = UIColor(red: 0.89, green: 0, blue: 0.44, alpha: 1)

        gradient.frame = bounds
        gradient.colors = [leftColor.cgColor, rightColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)

        return gradient
    }()

    // MARK: - View Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 60)
    }

}

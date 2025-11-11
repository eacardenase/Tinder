//
//  SendMessageButton.swift
//  Tinder
//
//  Created by Edwin Cardenas on 11/11/25.
//

import UIKit

class SendMessageButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let gradientLayer = CAGradientLayer()
        let leftColor = UIColor(red: 0.99, green: 0.35, blue: 0.37, alpha: 1)
        let rightColor = UIColor(red: 0.89, green: 0, blue: 0.44, alpha: 1)

        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true

        gradientLayer.frame = rect
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 50)
    }

}

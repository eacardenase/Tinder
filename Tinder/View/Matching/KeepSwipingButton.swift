//
//  KeepSwipingButton.swift
//  Tinder
//
//  Created by Edwin Cardenas on 11/11/25.
//

import UIKit

class KeepSwipingButton: UIButton {

    // MARK: - Properties

    private var cornerRadius: CGFloat {
        return frame.height / 2
    }

    private lazy var maskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        let maskPath = CGMutablePath()

        maskPath.addPath(
            UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        )

        maskPath.addPath(
            UIBezierPath(
                roundedRect: bounds.insetBy(dx: 2, dy: 2),
                cornerRadius: cornerRadius
            ).cgPath
        )

        layer.path = maskPath
        layer.fillRule = .evenOdd

        return layer
    }()

    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()

        let leftColor = UIColor(red: 0.99, green: 0.35, blue: 0.37, alpha: 1)
        let rightColor = UIColor(red: 0.89, green: 0, blue: 0.44, alpha: 1)

        gradient.frame = bounds
        gradient.colors = [leftColor.cgColor, rightColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.mask = maskLayer

        return gradient
    }()

    // MARK: - View Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 50)
    }

}

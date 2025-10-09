//
//  UIViewController+GradientLayer.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/8/25.
//

import UIKit

extension UIViewController {

    func configureGradientLayer() {
        let gradientLayer = CAGradientLayer()
        let topColor = UIColor(red: 0.99, green: 0.35, blue: 0.37, alpha: 1)
        let bottomColor = UIColor(red: 0.89, green: 0, blue: 0.44, alpha: 1)

        gradientLayer.frame = view.frame
        gradientLayer.locations = [0, 1]
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]

        view.layer.addSublayer(gradientLayer)
    }

}

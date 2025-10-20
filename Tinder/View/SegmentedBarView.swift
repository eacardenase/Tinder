//
//  SegmentedBarView.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/20/25.
//

import UIKit

class SegmentedBarView: UIStackView {

    // MARK: - Properties

    // MARK: - Initializers

    init(numberOfSegments: Int) {
        super.init(frame: .zero)

        (0..<numberOfSegments).forEach { _ in
            let barView = UIView()

            barView.backgroundColor = .black.withAlphaComponent(0.1)

            let barViewHeightAnchor = barView.heightAnchor.constraint(
                equalToConstant: 4
            )

            barViewHeightAnchor.isActive = true
            barView.layer.cornerRadius = barViewHeightAnchor.constant / 2

            addArrangedSubview(barView)
        }

        translatesAutoresizingMaskIntoConstraints = false
        spacing = 8
        distribution = .fillEqually
        arrangedSubviews.first?.backgroundColor = .white
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Helpers

extension SegmentedBarView {

    func highlightSegment(at index: Int) {
        arrangedSubviews.enumerated().forEach { idx, view in
            view.backgroundColor =
                idx == index
                ? .white : .black.withAlphaComponent(0.1)
        }
    }

}

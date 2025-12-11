//
//  DividerView.swift
//  Tinder
//
//  Created by Edwin Cardenas on 12/10/25.
//

import UIKit

class DividerView: UIView {

    // MARK: - Properties

    private let divider1: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .white.withAlphaComponent(0.25)

        return view
    }()

    private let label: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "OR"
        label.textColor = .white.withAlphaComponent(0.87)
        label.font = .systemFont(ofSize: 14)

        return label
    }()

    private let divider2: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .white.withAlphaComponent(0.25)

        return view
    }()

    // MARK: - View Lifecycle

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Helpers

extension DividerView {

    private func setupViews() {
        addSubview(divider1)
        addSubview(label)
        addSubview(divider2)

        //         divider1
        NSLayoutConstraint.activate([
            divider1.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            divider1.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 8
            ),
            divider1.trailingAnchor.constraint(
                equalTo: label.leadingAnchor,
                constant: -8
            ),
        ])

        // label
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        // divider2
        NSLayoutConstraint.activate([
            divider2.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            divider2.leadingAnchor.constraint(
                equalTo: label.trailingAnchor,
                constant: 8
            ),
            divider2.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -8
            ),
        ])
    }

}

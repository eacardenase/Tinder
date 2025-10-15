//
//  SettingsCell.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/14/25.
//

import UIKit

class SettingsCell: UITableViewCell {

    // MARK: - Properties

    lazy var inputField: UITextField = {
        let textField = UITextField()
        let spacer = UIView()

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 16)
        textField.placeholder = "Enter value here..."

        return textField
    }()

    let minAgeLabel = UILabel()
    let maxAgeLabel = UILabel()

    lazy var minAgeSlider = makeAgeRangeSlider()
    lazy var maxAgeSlider = makeAgeRangeSlider()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Helpers

extension SettingsCell {

    private func setupViews() {
        contentView.addSubview(inputField)

        // inputField
        NSLayoutConstraint.activate([
            inputField.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 16,
            ),
            inputField.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 24
            ),
            inputField.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -24
            ),
            inputField.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -16
            ),
        ])
    }

    private func makeAgeRangeSlider() -> UISlider {
        let slider = UISlider()

        slider.minimumValue = 18
        slider.maximumValue = 60
        slider.addTarget(
            self,
            action: #selector(ageRangeChanged),
            for: .valueChanged
        )

        return slider
    }

}

// MARK: - Actions

extension SettingsCell {

    @objc func ageRangeChanged(_ sender: UISlider) {

    }

}

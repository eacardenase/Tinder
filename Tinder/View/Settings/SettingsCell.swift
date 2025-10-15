//
//  SettingsCell.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/14/25.
//

import UIKit

class SettingsCell: UITableViewCell {

    // MARK: - Properties

    var viewModel: SettingsViewModel? {
        didSet { configure() }
    }

    lazy var inputField: UITextField = {
        let textField = UITextField()
        let spacer = UIView()

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 16)
        textField.placeholder = "Enter value here..."

        return textField
    }()

    private let minAgeLabel: UILabel = {
        let label = UILabel()

        label.text = "Min: 18"

        return label
    }()

    private let maxAgeLabel: UILabel = {
        let label = UILabel()

        label.text = "Max: 60"

        return label
    }()

    lazy var minAgeSlider = makeAgeRangeSlider()
    lazy var maxAgeSlider = makeAgeRangeSlider()

    private let sliderStack = UIStackView()

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
        let minStack = UIStackView(arrangedSubviews: [
            minAgeLabel, minAgeSlider,
        ])

        minStack.spacing = 24

        let maxStack = UIStackView(arrangedSubviews: [
            maxAgeLabel, maxAgeSlider,
        ])

        maxStack.spacing = 24

        sliderStack.addArrangedSubview(minStack)
        sliderStack.addArrangedSubview(maxStack)

        sliderStack.translatesAutoresizingMaskIntoConstraints = false
        sliderStack.axis = .vertical
        sliderStack.spacing = 16

        let primaryStackView = UIStackView(arrangedSubviews: [
            inputField,
            sliderStack,
        ])

        primaryStackView.translatesAutoresizingMaskIntoConstraints = false
        primaryStackView.axis = .vertical

        contentView.addSubview(primaryStackView)

        // sliderStack
        NSLayoutConstraint.activate([
            primaryStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 16
            ),
            primaryStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 24
            ),
            primaryStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -24
            ),
            primaryStackView.bottomAnchor.constraint(
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

    private func configure() {
        guard let viewModel else { return }

        inputField.isHidden = viewModel.shouldHideInputField
        sliderStack.isHidden = viewModel.shouldHideSlider
    }

}

// MARK: - Actions

extension SettingsCell {

    @objc func ageRangeChanged(_ sender: UISlider) {

    }

}

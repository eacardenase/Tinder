//
//  SettingsCell.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/14/25.
//

import UIKit

class SettingsCell: UITableViewCell {

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
        backgroundColor = .systemBlue
    }

}

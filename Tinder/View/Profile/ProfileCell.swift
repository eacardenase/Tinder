//
//  ProfileCell.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/17/25.
//

import SDWebImage
import UIKit

class ProfileCell: UICollectionViewCell {

    // MARK: - Properties

    var imageUrl: URL? {
        didSet { configure() }
    }

    private let imageView: UIImageView = {
        let _imageView = UIImageView()

        _imageView.translatesAutoresizingMaskIntoConstraints = false
        _imageView.contentMode = .scaleAspectFill

        return _imageView
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Helpers

extension ProfileCell {

    private func setupViews() {
        clipsToBounds = true

        contentView.addSubview(imageView)

        // imageView
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            imageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            imageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),
        ])
    }

    private func configure() {
        guard let imageUrl else { return }

        imageView.sd_setImage(with: imageUrl)
    }

}

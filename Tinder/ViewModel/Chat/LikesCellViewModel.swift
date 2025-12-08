//
//  LikesCellViewModel.swift
//  Tinder
//
//  Created by Edwin Cardenas on 12/7/25.
//

import Foundation

struct LikesCellViewModel {

    // MARK: - Properties

    private let count: Int

    var likesCountText: String {
        return count > 99 ? "99+" : "\(count)"
    }

    // MARK: - Initializers

    init(count: Int) {
        self.count = count
    }

}

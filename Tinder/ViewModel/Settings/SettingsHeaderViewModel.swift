//
//  SettingsHeaderViewModel.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/16/25.
//

import Foundation

struct SettingsHeaderViewModel {

    let user: User

    var imageUrls: [URL?] {
        return user.imageUrls.map { URL(string: $0) }
    }

}

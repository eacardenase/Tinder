//
//  SettingsViewModel.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/14/25.
//

import Foundation

enum SettingsSections: Int, CaseIterable {
    case name
    case profession
    case age
    case bio
    case ageRange

    var description: String {
        switch self {
        case .name: return "Name"
        case .profession: return "Profession"
        case .age: return "Age"
        case .bio: return "Bio"
        case .ageRange: return "Seeking age Range"
        }
    }
}

struct SettingsViewModel {

    // MARK: - Properties

    private let user: User
    private let section: SettingsSections

    var shouldHideInputField: Bool {
        return section == .ageRange
    }

    var shouldHideSlider: Bool {
        return !shouldHideInputField
    }

    // MARK: - Initializers

    init(user: User, section: SettingsSections) {
        self.user = user
        self.section = section
    }

}

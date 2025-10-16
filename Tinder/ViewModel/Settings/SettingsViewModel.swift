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

    let user: User
    let section: SettingsSections

    var value: String? {
        switch section {
        case .name: return user.fullname
        case .profession: return user.profession
        case .age: return "\(user.age)"
        case .bio: return user.bio
        case .ageRange: return "NA"
        }
    }

    var placeholderText: String {
        return "Enter \(section.description.lowercased())..."
    }

    var shouldHideInputField: Bool {
        return section == .ageRange
    }

    var shouldHideSlider: Bool {
        return !shouldHideInputField
    }

}

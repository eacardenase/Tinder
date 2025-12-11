//
//  ResetPasswordViewModel.swift
//  Tinder
//
//  Created by Edwin Cardenas on 12/10/25.
//

import Foundation

struct ResetPasswordViewModel: AuthenticationViewModelProtocol {

    var email: String?

    var formIsValid: Bool {
        return email?.isEmpty == false
    }

}

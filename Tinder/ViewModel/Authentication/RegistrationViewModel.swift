//
//  RegistrationViewModel.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/9/25.
//

import Foundation

struct RegistrationViewModel: AuthenticationViewModelProtocol {

    var fullname: String?
    var email: String?
    var password: String?

    var formIsValid: Bool {
        return fullname?.isEmpty == false
            && email?.isEmpty == false
            && password?.isEmpty == false
    }

}

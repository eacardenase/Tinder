//
//  LoginViewModel.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/9/25.
//

import Foundation

struct LoginViewModel: AuthenticationViewModelProtocol {

    var email: String?
    var password: String?

    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
    }

}

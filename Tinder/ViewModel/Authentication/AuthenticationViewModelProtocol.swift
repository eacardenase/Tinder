//
//  AuthenticationViewModelProtocol.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/9/25.
//

import UIKit

protocol AuthenticationDelegate: AnyObject {

    func authenticationComplete()

}

protocol AuthenticationProtocol {

    func updateForm()

}

protocol AuthenticationViewModelProtocol {

    var formIsValid: Bool { get }
    var shouldEnableButton: Bool { get }
    var buttonTitleColor: UIColor { get }
    var buttonBackgroundColor: UIColor { get }

}

extension AuthenticationViewModelProtocol {

    var shouldEnableButton: Bool {
        return formIsValid
    }

    var buttonTitleColor: UIColor {
        return formIsValid ? .white : .white.withAlphaComponent(0.7)
    }

    var buttonBackgroundColor: UIColor {
        return formIsValid
            ? .clear : .white.withAlphaComponent(0.2)
    }

}

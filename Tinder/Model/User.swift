//
//  User.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/7/25.
//

import UIKit

struct User: Codable {

    let uid: String
    var fullname: String
    var email: String
    var age: Int
    var imageUrls: [String]

}

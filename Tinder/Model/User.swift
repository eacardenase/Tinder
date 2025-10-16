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
    var bio: String?
    var profession: String?
    var minSeekingAge: Int = 18
    var maxSeekingAge: Int = 40
    var imageUrls: [String]

}

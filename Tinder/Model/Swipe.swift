//
//  Swipe.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/21/25.
//

import Foundation

struct Swipe: Codable {

    let userId: String
    let targetId: String
    let direction: SwipeDirection

}

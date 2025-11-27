//
//  Message.swift
//  Tinder
//
//  Created by Edwin Cardenas on 11/26/25.
//

import FirebaseCore
import Foundation

struct Message: Codable {

    let text: String
    let toId: String
    let fromId: String
    let timestamp: Timestamp

    var isFromCurrentUser: Bool {
        return fromId == AuthService.currentUser?.uid
    }

    var chatPartnerId: String {
        return isFromCurrentUser ? toId : fromId
    }

}

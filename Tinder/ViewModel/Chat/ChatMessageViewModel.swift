//
//  ChatMessageViewModel.swift
//  Tinder
//
//  Created by Edwin Cardenas on 11/26/25.
//

import UIKit

struct ChatMessageCellViewModel {

    private let message: Message

    var messageBackgroundColor: UIColor {
        return message.isFromCurrentUser ? .systemPink : .lightGray
    }

    var messageTextColor: UIColor {
        return message.isFromCurrentUser ? .white : .black
    }

    var timestamp: String {
        let date = message.timestamp.dateValue()
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "hh:mm a"

        return dateFormatter.string(from: date)
    }

    var trailingAnchorActive: Bool {
        return !message.isFromCurrentUser
    }

    var leadingAnchorActive: Bool {
        return message.isFromCurrentUser
    }

    var shouldHideProfileImage: Bool {
        return !message.isFromCurrentUser
    }

    init(message: Message) {
        self.message = message
    }

}

//
//  Constants.swift
//  Tinder
//
//  Created by Edwin Cardenas on 11/26/25.
//

import FirebaseFirestore

struct Constants {

    private init() {}

    struct FirebaseFirestore {

        private init() {}

        static let UsersCollection = Firestore.firestore().collection("users")

        static let MatchesMessagesCollection = Firestore.firestore().collection(
            "matches_messages"
        )

    }

}

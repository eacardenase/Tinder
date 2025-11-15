//
//  MatchService.swift
//  Tinder
//
//  Created by Edwin Cardenas on 11/14/25.
//

import FirebaseFirestore
import Foundation

struct MatchService {

    private init() {}

    static func saveMatch(
        for currentUser: User,
        with matchedUser: User,
        completion: @escaping (NetworkingError?) -> Void
    ) {
        guard
            let matchedUserImageUrl = matchedUser.imageUrls.first,
            let currentUserImageUrl = currentUser.imageUrls.first
        else { return }

        let currentUserMatch = Match(
            profileUid: currentUser.uid,
            name: currentUser.fullname,
            profileImageUrl: currentUserImageUrl
        )

        let matchedUserMatch = Match(
            profileUid: matchedUser.uid,
            name: matchedUser.fullname,
            profileImageUrl: matchedUserImageUrl
        )

        do {
            try Firestore.firestore()
                .collection("matches_messages")
                .document(currentUser.uid)
                .collection("matches")
                .addDocument(from: currentUserMatch)

            try Firestore.firestore()
                .collection("matches_messages")
                .document(matchedUser.uid)
                .collection("matches")
                .addDocument(from: matchedUserMatch)

            completion(nil)
        } catch {
            completion(.serverError(error.localizedDescription))
        }
    }

}

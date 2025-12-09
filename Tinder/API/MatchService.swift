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
            profileImageUrl: currentUserImageUrl,
            isNew: true
        )

        let matchedUserMatch = Match(
            profileUid: matchedUser.uid,
            name: matchedUser.fullname,
            profileImageUrl: matchedUserImageUrl,
            isNew: true
        )

        do {
            try Firestore.firestore()
                .collection("matches_messages")
                .document(currentUser.uid)
                .collection("matches")
                .addDocument(from: matchedUserMatch)

            try Firestore.firestore()
                .collection("matches_messages")
                .document(matchedUser.uid)
                .collection("matches")
                .addDocument(from: currentUserMatch)

            completion(nil)
        } catch {
            completion(.serverError(error.localizedDescription))
        }
    }

    static func updateMatch(
        for user: User,
        completion: @escaping (NetworkingError?) -> Void
    ) {
        guard let currentUserId = AuthService.currentUser?.uid else { return }

        Firestore.firestore().collection("matches_messages")
            .document(currentUserId)
            .collection("matches")
            .whereField("profileUid", isEqualTo: user.uid)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error {
                    completion(.serverError(error.localizedDescription))

                    return
                }

                guard let snapshot,
                    let document = snapshot.documents.first
                else {
                    completion(.serverError("There are no likes yet."))

                    return
                }

                document.reference.updateData(
                    ["isNew": false]
                ) { error in
                    if let error {
                        completion(.serverError(error.localizedDescription))
                    }
                }
            }
    }

    static func fetchMatches(
        for user: User,
        completion: @escaping (Result<[Match], NetworkingError>) -> Void
    ) {
        Firestore.firestore().collection("matches_messages")
            .document(user.uid)
            .collection("matches")
            .getDocuments { snapshot, error in
                if let error {
                    completion(
                        .failure(.serverError(error.localizedDescription))
                    )

                    return
                }

                guard let snapshot else {
                    completion(
                        .failure(.serverError("Failed to get matches."))
                    )

                    return
                }

                let matches = snapshot.documents.compactMap {
                    try? $0.data(as: Match.self)
                }

                completion(.success(matches))
            }
    }

}

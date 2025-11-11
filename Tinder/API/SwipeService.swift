//
//  SwipeService.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/21/25.
//

import FirebaseFirestore

struct SwipeService {

    private init() {}

    static func saveSwipe(
        for user: User,
        with direction: SwipeDirection,
        completion: @escaping (Result<Swipe, NetworkingError>) -> Void
    ) {
        guard let currentUserId = AuthService.currentUser?.uid else { return }

        let swipe = Swipe(
            userId: currentUserId,
            targetId: user.uid,
            direction: direction
        )

        do {
            try Firestore.firestore().collection("swipes")
                .addDocument(from: swipe)

            DispatchQueue.main.async {
                completion(.success(swipe))
            }
        } catch {
            DispatchQueue.main.async {
                completion(
                    .failure(
                        .serverError(error.localizedDescription)
                    )
                )
            }
        }

    }

    static func checkIfMatchExists(
        for swipe: Swipe,
        completion: @escaping (Result<SwipeDirection, NetworkingError>) -> Void
    ) {
        Firestore.firestore().collection("swipes")
            .whereField("userId", isEqualTo: swipe.userId)
            .whereField("targetId", isEqualTo: swipe.targetId)
            .limit(to: 1)
            .getDocuments {
                (snapshot, error) in

                if let error {
                    completion(
                        .failure(.serverError(error.localizedDescription))
                    )

                    return
                }

                guard let snapshot,
                    let document = snapshot.documents.first
                else {
                    completion(
                        .failure(
                            .serverError(
                                "The user \(swipe.userId) has no swipe for user \(swipe.targetId)"
                            )
                        )
                    )

                    return
                }

                do {
                    let matchedSwipe = try document.data(as: Swipe.self)

                    completion(.success(matchedSwipe.direction))
                } catch {
                    completion(
                        .failure(.serverError("Failed to get swipe data."))
                    )
                }
            }
    }

}

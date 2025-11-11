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
        completion: @escaping (NetworkingError?) -> Void
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
                completion(nil)
            }
        } catch {
            DispatchQueue.main.async {
                completion(.serverError(error.localizedDescription))
            }
        }

    }

    static func checkIfMatchExists(
        for user: User,
        completion: @escaping (Result<SwipeDirection, NetworkingError>) -> Void
    ) {
        guard let currentUserId = AuthService.currentUser?.uid else { return }

        Firestore.firestore().collection("swipes")
            .whereField("userId", isEqualTo: currentUserId)
            .whereField("targetId", isEqualTo: user.uid).getDocuments {
                (snapshot, error) in

                if let error {
                    completion(
                        .failure(.serverError(error.localizedDescription))
                    )

                    return
                }

                guard let snapshot else {
                    completion(
                        .failure(.serverError("Failed to get swipe data."))
                    )

                    return
                }

                let swipes = snapshot.documents.compactMap { document in
                    return try? document.data(as: Swipe.self)
                }

                guard let swipe = swipes.first else {
                    completion(
                        .failure(
                            .serverError(
                                "The user \(currentUserId) has no swipe for user \(user.uid)"
                            )
                        )
                    )

                    return
                }

                completion(.success(swipe.direction))
            }
    }

}

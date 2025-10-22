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

}

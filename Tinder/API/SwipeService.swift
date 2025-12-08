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
        completion: @escaping (Result<Bool, NetworkingError>) -> Void
    ) {
        Firestore.firestore().collection("swipes")
            .whereField("userId", isEqualTo: swipe.targetId)
            .whereField("targetId", isEqualTo: swipe.userId)
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
                    completion(.success(false))

                    return
                }

                do {
                    let matchedSwipe = try document.data(as: Swipe.self)
                    let matchExists = matchedSwipe.direction == .right

                    completion(.success(matchExists))
                } catch {
                    completion(
                        .failure(.serverError("Failed to get swipe data."))
                    )
                }
            }
    }

    static func fetchSwipes(
        for user: User,
        completion: @escaping (Result<[Swipe], NetworkingError>) -> Void
    ) {
        Firestore.firestore().collection("swipes")
            .whereField("userId", isEqualTo: user.uid)
            .getDocuments { snapshot, error in
                if let error {
                    completion(
                        .failure(.serverError(error.localizedDescription))
                    )

                    return
                }

                guard let snapshot else {
                    completion(
                        .failure(
                            .serverError(
                                "Failed to get swipes for user with uid \(user.uid)"
                            )
                        )
                    )

                    return
                }

                let swipes = snapshot.documents.compactMap { document in
                    return try? document.data(as: Swipe.self)
                }

                completion(.success(swipes))
            }
    }

    static func fetchLikesCount(
        for user: User,
        completion: @escaping (Result<Int, NetworkingError>) -> Void
    ) {
        let query = Firestore.firestore().collection("swipes")
            .whereField("targetId", isEqualTo: user.uid)
            .whereField("direction", isEqualTo: 1)

        query.count.getAggregation(source: .server) { snapshot, error in
            if let error {
                completion(.failure(.serverError(error.localizedDescription)))

                return
            }

            guard let snapshot else {
                completion(
                    .failure(.serverError("There are no items to fetch"))
                )

                return
            }

            completion(.success(snapshot.count.intValue))
        }
    }

}

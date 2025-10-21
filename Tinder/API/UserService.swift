//
//  UserService.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/9/25.
//

import FirebaseFirestore

struct UserService {

    private init() {}

    static func store(
        _ user: User,
        completion: @escaping (Result<User, NetworkingError>) -> Void
    ) {
        do {
            try Firestore
                .firestore()
                .collection("users")
                .document(user.uid)
                .setData(from: user)

            completion(.success(user))
        } catch {
            completion(.failure(.serverError(error.localizedDescription)))
        }
    }

    static func fetchUser(
        withId userId: String,
        completion: @escaping (Result<User, NetworkingError>) -> Void
    ) {
        Firestore.firestore().collection("users").document(userId).getDocument {
            (snapshot, error) in

            if let error {
                completion(
                    .failure(.serverError(error.localizedDescription))
                )

                return
            }

            guard let snapshot else {
                completion(
                    .failure(.serverError("Failed to get user data."))
                )

                return
            }

            do {
                let user = try snapshot.data(as: User.self)

                completion(.success(user))
            } catch {
                completion(.failure(.decodingError))
            }
        }
    }

    static func fetchUsers(
        completion: @escaping (Result<[User], NetworkingError>) -> Void
    ) {
        guard let currentUserId = AuthService.currentUser?.uid else { return }

        Firestore.firestore().collection("users")
//            .whereField(
//            "uid",
//            isNotEqualTo: currentUserId
//        )
            .getDocuments {
            (snapshot, error) in

            if let error {
                completion(
                    .failure(.serverError(error.localizedDescription))
                )

                return
            }

            guard let snapshot else {
                completion(
                    .failure(.serverError("Failed to get users data."))
                )

                return
            }

            let users = snapshot.documents.compactMap { document in
                return try? document.data(as: User.self)
            }

            completion(.success(users))
        }
    }

}

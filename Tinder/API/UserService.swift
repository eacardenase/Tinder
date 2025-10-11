//
//  UserService.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/9/25.
//

import FirebaseFirestore

struct UserService {

    private init() {}

    static func storeUser(
        withId uid: String,
        data: [String: Any],
        completion: @escaping (Result<User?, NetworkingError>) -> Void
    ) {

        Firestore.firestore().collection("users").document(uid).setData(data) {
            error in
            if let error {
                completion(.failure(.serverError(error.localizedDescription)))

                return
            }

            completion(.success(nil))
        }
    }

}

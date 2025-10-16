//
//  AuthService.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/9/25.
//

import FirebaseAuth
import UIKit

enum NetworkingError: Error {
    case decodingError
    case serverError(String)
}

struct AuthCredentials {
    let fullname: String
    let email: String
    let password: String
    let profileImage: UIImage
}

struct AuthService {

    private init() {}

    static var currentUser: FirebaseAuth.User? {
        return Auth.auth().currentUser
    }

    static func createUser(
        wih credentials: AuthCredentials,
        completion: @escaping (Result<User, NetworkingError>) -> Void
    ) {
        Auth.auth().createUser(
            withEmail: credentials.email,
            password: credentials.password
        ) { result, error in

            if let error {
                completion(
                    .failure(.serverError(error.localizedDescription))
                )

                return
            }

            guard let uid = result?.user.uid else {
                completion(
                    .failure(.serverError("Failed to get user id."))
                )

                return
            }

            StorageService.upload(credentials.profileImage, for: uid) {
                result in

                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let url):
                    let user = User(
                        uid: uid,
                        fullname: credentials.fullname,
                        email: credentials.email,
                        age: 18,
                        imageUrls: [url]
                    )

                    UserService.store(
                        user,
                        completion: completion
                    )
                }
            }
        }
    }

    static func verifyLogin(
        completion: @escaping (Result<User, NetworkingError>) -> Void
    ) {
        guard
            let currentUserId = Auth.auth().currentUser?.uid
        else {
            completion(
                .failure(
                    .serverError("Failed to get user, current user is nil.")
                )
            )

            return
        }

        UserService.fetchUser(withId: currentUserId, completion: completion)
    }

    static func logUserIn(
        withEmail email: String,
        password: String,
        completion: @escaping (Error?) -> Void
    ) {
        Auth.auth().signIn(withEmail: email, password: password) {
            result,
            error in

            if let error {
                completion(error)

                return
            }

            completion(nil)
        }
    }

    static func logUserOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()

            completion(nil)
        } catch {
            completion(error)
        }
    }

}

//
//  AuthService.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/9/25.
//

import FirebaseAuth
import GoogleSignIn
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

            StorageService.upload(credentials.profileImage, forUserId: uid) {
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

    static func signInWithGoogle(
        withPresenting presentingViewController: UIViewController,
        useFirestore: Bool = true,
        completion: @escaping (Result<User, NetworkingError>) -> Void
    ) {
        GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController
        ) { signInResult, error in
            if let error {
                completion(.failure(.serverError(error.localizedDescription)))

                return
            }

            guard let signInResult else {
                completion(
                    .failure(
                        .serverError("DEBUG: Found nil in Google signInResult.")
                    )
                )

                return
            }

            let user = signInResult.user

            if let profile = user.profile, profile.hasImage {
                let profileImageUrl = profile.imageURL(withDimension: 600)
            }

            guard let userId = user.idToken,
                let email = user.profile?.email,
                let fullname = user.profile?.name
            else {
                completion(
                    .failure(
                        .serverError(
                            "DEBUG: Error getting user details from Google"
                        )
                    )
                )

                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: userId.tokenString,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { result, error in
                if let error {
                    completion(
                        .failure(.serverError(error.localizedDescription))
                    )

                    return
                }

                guard let uid = result?.user.uid else {
                    return
                }

                let user = User(
                    uid: uid,
                    fullname: fullname,
                    email: email,
                    age: 18,
                    imageUrls: []
                )

                UserService.store(user, completion: completion)
            }

        }

        //        GIDSignIn.sharedInstance.signIn(
        //            withPresenting: presentingViewController
        //        ) {
        //            Auth.auth().signIn(with: credential) { result, error in
        //                if let error {
        //                    completion(
        //                        .failure(.serverError(error.localizedDescription))
        //                    )
        //
        //                    return
        //                }
        //
        //                guard let uid = result?.user.uid else {
        //                    return
        //                }
        //
        //                fetchUser(useFirestore: useFirestore) { result in
        //                    switch result {
        //                    case .success(let user):
        //                        completion(.success(user))
        //                    case .failure:
        //                        let values = [
        //                            "email": email,
        //                            "fullname": fullname,
        //                        ]
        //
        //                        signUpFirebaseUser(
        //                            withUid: uid,
        //                            data: values,
        //                            useFirestore: useFirestore,
        //                            completion: completion
        //                        )
        //                    }
        //                }
        //            }
        //        }
    }

    static func signUpFirebaseUser(
        withUid uid: String,
        data: [String: String],
        useFirestore: Bool = true,
        completion: @escaping (Result<User, NetworkingError>) -> Void
    ) {
        //        let values: [String: Any] = [
        //            "email": data["email"] ?? "",
        //            "fullname": data["fullname"] ?? "",
        //            "hasSeenOnboarding": false,
        //        ]
        //
        //        let credentials = AuthCredentials(
        //            fullname: fullname,
        //            email: email,
        //            password: password,
        //            profileImage: profileImage
        //        )
        //
        //        Constants.FirebaseFirestore.USERS_COLLECTION.document(uid).setData(
        //            values
        //        ) { error in
        //            if let error {
        //                completion(
        //                    .failure(.serverError(error.localizedDescription))
        //                )
        //
        //                return
        //            }
        //
        //            fetchUser(useFirestore: true, completion: completion)
        //        }

    }

}

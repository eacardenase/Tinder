//
//  ChatService.swift
//  Tinder
//
//  Created by Edwin Cardenas on 11/26/25.
//

import FirebaseCore
import FirebaseFirestore

struct ChatService {

    static func upload(
        _ text: String,
        to user: User,
        completion: @escaping (Error?) -> Void
    ) {
        guard let currentUserUid = AuthService.currentUser?.uid else { return }

        let message = Message(
            text: text,
            toId: currentUserUid,
            fromId: user.uid,
            timestamp: Timestamp()
        )

        do {
            try Constants
                .FirebaseFirestore
                .MatchesMessagesCollection
                .document(currentUserUid)
                .collection(user.uid)
                .addDocument(from: message)

            try Constants.FirebaseFirestore.MatchesMessagesCollection.document(
                user.uid
            ).collection(currentUserUid).addDocument(
                from: message,
            )

            try Constants.FirebaseFirestore.MatchesMessagesCollection.document(
                currentUserUid
            ).collection("recent_messages").document(user.uid).setData(
                from: message
            )

            try Constants.FirebaseFirestore.MatchesMessagesCollection.document(
                user.uid
            ).collection("recent_messages").document(currentUserUid).setData(
                from: message
            )
        } catch {
            completion(error)
        }
    }

    static func fetchMessages(
        for user: User,
        completion: @escaping ([Message]) -> Void
    ) {
        guard let currentUserId = AuthService.currentUser?.uid else { return }

        let query = Constants.FirebaseFirestore.MatchesMessagesCollection.document(
            currentUserId
        ).collection(user.uid)
            .limit(to: 50)
            .order(by: "timestamp")

        query.addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                return
            }

            let messages = documents.compactMap {
                return try? $0.data(as: Message.self)
            }

            completion(messages)
        }
    }

    static func fetchRecentMessages(
        completion:
            @escaping (Result<[Conversation], NetworkingError>) ->
            Void
    ) {
        guard let currentUserId = AuthService.currentUser?.uid else {
            completion(.failure(.serverError("User not logged in.")))

            return
        }

        var recentMessages: [String: Conversation] = [:]

        let query = Constants.FirebaseFirestore.MatchesMessagesCollection.document(
            currentUserId
        ).collection("recent_messages")

        query.addSnapshotListener { snapshot, error in
            if let error {
                completion(.failure(.serverError(error.localizedDescription)))

                return
            }

            guard let snapshot else {
                completion(
                    .failure(.serverError("Error getting conversations."))
                )

                return
            }

            snapshot.documents.forEach { document in
                do {
                    let message = try document.data(as: Message.self)

                    UserService.fetchUser(withId: message.chatPartnerId) {
                        result in

                        switch result {
                        case .success(let user):
                            let conversation = Conversation(
                                user: user,
                                message: message
                            )

                            recentMessages[user.uid] = conversation

                            completion(.success(Array(recentMessages.values)))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } catch {
                    completion(
                        .failure(.serverError(error.localizedDescription))
                    )
                }
            }
        }
    }

}

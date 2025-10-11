//
//  StorageService.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/9/25.
//

import FirebaseStorage
import UIKit

struct StorageService {

    private init() {}

    static func upload(
        _ image: UIImage,
        for userId: String,
        completion: @escaping (Result<String, NetworkingError>) -> Void
    ) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(
                .failure(.serverError("Image data could not be compressed."))
            )

            return
        }

        let filename = UUID().uuidString
        let ref = Storage.storage().reference(
            withPath: "/images/\(userId)/\(filename)"
        )

        ref.putData(imageData) { result in
            switch result {
            case .failure(let error):
                completion(.failure(.serverError(error.localizedDescription)))
            case .success:
                getDownloadUrl(for: ref, completion: completion)
            }
        }
    }

    private static func getDownloadUrl(
        for ref: StorageReference,
        completion: @escaping (Result<String, NetworkingError>) -> Void
    ) {
        ref.downloadURL { result in
            switch result {
            case .failure(let error):
                completion(
                    .failure(.serverError(error.localizedDescription))
                )
            case .success(let url):
                completion(.success(url.absoluteString))
            }
        }
    }

}

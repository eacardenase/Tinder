//
//  ChatController.swift
//  Tinder
//
//  Created by Edwin Cardenas on 11/26/25.
//

import UIKit

class ChatController: UICollectionViewController {

    // MARK: - Properties

    private let user: User
    private var messages = [Message]()
    var fromCurrentUser = false

    private lazy var customInputView: CustomInputAccessoryView = {
        let inputView = CustomInputAccessoryView()

        inputView.delegate = self

        return inputView
    }()

    // MARK: - Initializers

    init(user: User) {
        self.user = user

        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override var inputAccessoryView: UIView? {
        return customInputView
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        fetchMessages()

        collectionView.keyboardDismissMode = .interactive
        collectionView.alwaysBounceVertical = true
        collectionView.register(
            ChatMessageCell.self,
            forCellWithReuseIdentifier: NSStringFromClass(
                ChatMessageCell.self
            )
        )

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )

        view.addGestureRecognizer(tapGesture)
    }

}

// MARK: - Helpers

extension ChatController {

    private func setupViews() {
        collectionView.backgroundColor = .white

        navigationItem.title = user.fullname
    }

}

// MARK: - Actions

extension ChatController {

    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        customInputView.endEditing(true)
    }

}

// MARK: - UICollectionViewDataSource

extension ChatController {

    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return messages.count
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NSStringFromClass(ChatMessageCell.self),
                for: indexPath
            ) as? ChatMessageCell
        else {
            fatalError("Could not instantiate ChatMessageCell")
        }

        let message = messages[indexPath.row]

        cell.message = message

        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension ChatController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimatedSizeCell = ChatMessageCell(frame: frame)

        estimatedSizeCell.message = messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()

        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        )

        return CGSize(width: view.frame.width, height: estimatedSize.height)
    }

}

// MARK: - CustomInputAccessoryViewDelegate

extension ChatController: CustomInputAccessoryViewDelegate {

    func inputView(
        _ inputView: CustomInputAccessoryView,
        wantsToSend message: String
    ) {
        inputView.clearMessageText()

        ChatService.upload(message, to: user) { error in
            if let error {
                print(
                    "DEBUG: Failed to upload message with error: \(error.localizedDescription)"
                )

                return
            }
        }
    }

}

// MARK: - API

extension ChatController {

    func fetchMessages() {
        ChatService.fetchMessages(for: user) { [weak self] messages in
            guard let self else { return }

            self.messages = messages
            let indexPath = IndexPath(item: self.messages.count - 1, section: 0)

            self.collectionView.reloadData()
            self.collectionView.scrollToItem(
                at: indexPath,
                at: .bottom,
                animated: true
            )
        }
    }

}

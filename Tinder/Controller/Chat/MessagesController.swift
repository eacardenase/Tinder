//
//  MessagesController.swift
//  Tinder
//
//  Created by Edwin Cardenas on 11/13/25.
//

import UIKit

class MessagesController: UITableViewController {

    // MARK: - Properties

    let user: User
    let headerView = MessagesHeader(
        frame: CGRect(x: 0, y: 0, width: 0, height: 180)
    )

    private var recentMessages = [Conversation]()

    // MARK: - Initializers

    init(user: User) {
        self.user = user

        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
        setupViews()
        fetchConversations()

        headerView.delegate = self

        tableView.tableHeaderView = headerView
        tableView.separatorStyle = .none
        tableView.register(
            ConversationCell.self,
            forCellReuseIdentifier: NSStringFromClass(ConversationCell.self)
        )
        tableView.register(
            NothingFoundCell.self,
            forCellReuseIdentifier: NSStringFromClass(NothingFoundCell.self)
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchMatches()

        headerView.reloadData()
    }

}

// MARK: - UITableViewDataSource

extension MessagesController {

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return !recentMessages.isEmpty ? recentMessages.count : 1
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: NSStringFromClass(ConversationCell.self),
                for: indexPath
            ) as? ConversationCell
        else { fatalError("Could not create ConversationCell cell") }

        if recentMessages.isEmpty {
            let nothingFoundCell = tableView.dequeueReusableCell(
                withIdentifier: NSStringFromClass(NothingFoundCell.self),
                for: indexPath
            )

            return nothingFoundCell
        }

        cell.conversation = recentMessages[indexPath.row]
        cell.selectionStyle = .none

        return cell
    }

}

// MARK: - UITableViewDelegate

extension MessagesController {

    override func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let view = UIView()
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Messages"
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .systemPink

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            label.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -16
            ),
        ])

        return view
    }

    override func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
        return !recentMessages.isEmpty ? indexPath : nil
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let user = recentMessages[indexPath.row].user

        showChatController(for: user)
    }

}

// MARK: - Helpers

extension MessagesController {

    private func setupViews() {
        let leftButton = UIBarButtonItem(
            image: UIImage(resource: .appIcon),
            style: .plain,
            target: self,
            action: #selector(leftButtonTapped)
        )
        let titleView = UIImageView(
            image: UIImage(resource: .topRightMessages).withRenderingMode(
                .alwaysTemplate
            )
        )

        leftButton.tintColor = .lightGray
        titleView.tintColor = .systemPink

        navigationItem.leftBarButtonItem = leftButton
        navigationItem.titleView = titleView
        navigationItem.backButtonTitle = ""
    }

    private func showChatController(for user: User) {
        let controller = ChatController(user: user)

        navigationController?.pushViewController(controller, animated: true)
    }

}

// MARK: - Actions

extension MessagesController {

    @objc func leftButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

}

// MARK: - API

extension MessagesController {

    private func fetchMatches() {
        MatchService.fetchMatches(for: user) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let matches):
                self.headerView.matches = matches
            case .failure(let error):
                print(error)
            }
        }
    }

    private func fetchData() {
        fetchLikesCount()
        fetchProfileImageUrl()
        fetchMatches()
    }

    private func fetchLikesCount() {
        SwipeService.fetchLikesCount(for: user) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let count):
                self.headerView.likesCount = count
            case .failure(let error):
                print(error)
            }
        }
    }

    private func fetchProfileImageUrl() {
        SwipeService.fetchSwipe(for: user) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let swipe):
                self.headerView.profileImageUrl = swipe.profileImageUrl
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchConversations() {
        ChatService.fetchRecentMessages { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let recentMessages):
                self.recentMessages = recentMessages.sorted(by: {
                    $0.message.timestamp.dateValue()
                        > $1.message.timestamp.dateValue()
                })

                self.tableView.reloadData()
            case .failure(let error):
                print(
                    "DEBUG: Failed to fetch conversations with error: \(error.localizedDescription)"
                )
            }
        }
    }

}

// MARK: - MessagesHeaderDelegate

extension MessagesController: MessagesHeaderDelegate {

    func messagesHeader(_ header: MessagesHeader, wantsToChatWith user: User) {
        showChatController(for: user)
    }

}

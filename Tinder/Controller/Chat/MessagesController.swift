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

        fetchMatches()
        setupViews()

        headerView.delegate = self

        tableView.tableHeaderView = headerView
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self)
        )
    }

}

// MARK: - UITableViewDataSource

extension MessagesController {

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 4
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NSStringFromClass(UITableViewCell.self),
            for: indexPath
        )

        cell.textLabel?.text = "\(indexPath.row)"

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
        MatchService.fetchMatches(for: user) { result in
            switch result {
            case .success(let matches):
                self.headerView.matches = matches
            case .failure(let error):
                print(error)
            }
        }
    }

}

// MARK: - MessagesHeaderDelegate

extension MessagesController: MessagesHeaderDelegate {

    func messagesHeader(_ header: MessagesHeader, wantsToChatWith user: User) {
        print("DEBUG: Start chat with \(user.fullname)")
    }

}

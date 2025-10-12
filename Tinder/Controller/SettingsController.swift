//
//  SettingsController.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/12/25.
//

import UIKit

class SettingsController: UITableViewController {

    // MARK: Properties

    private let headerView = SettingsHeader()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

}

// MARK: - Helpers

extension SettingsController {

    private func setupViews() {
        view.backgroundColor = .white

        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonTapped)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )

        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
        tableView.backgroundColor = .systemGroupedBackground
    }

}

// MARK: - Actions

extension SettingsController {

    @objc func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        print(#function)
    }

}

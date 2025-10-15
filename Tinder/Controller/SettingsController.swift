//
//  SettingsController.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/12/25.
//

import UIKit

class SettingsController: UITableViewController {

    // MARK: Properties

    private lazy var headerView: SettingsHeader = {
        let header = SettingsHeader()

        header.delegate = self

        return header
    }()

    private var buttonIndex = 0

    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()

        picker.delegate = self

        return picker
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        tableView.register(
            SettingsCell.self,
            forCellReuseIdentifier: NSStringFromClass(SettingsCell.self)
        )
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

// MARK: - SettingsHeaderDelegate

extension SettingsController: SettingsHeaderDelegate {

    func settingsHeader(_ header: SettingsHeader, didSelectButtonAt index: Int)
    {
        buttonIndex = index

        present(imagePicker, animated: false)
    }

}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension SettingsController: UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:
            Any]
    ) {
        let image = info[.originalImage] as? UIImage
        let button = headerView.buttons[buttonIndex]

        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)

        dismiss(animated: true)
    }

}

// MARK: - UITableViewDataSource

extension SettingsController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSections.allCases.count
    }

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 2
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NSStringFromClass(SettingsCell.self),
            for: indexPath
        )

        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 32
    }

    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        guard let section = SettingsSections(rawValue: section) else {
            return nil
        }

        return section.description
    }

}

// MARK: - UITableViewDelegate

extension SettingsController {

}

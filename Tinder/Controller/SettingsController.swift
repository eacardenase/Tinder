//
//  SettingsController.swift
//  Tinder
//
//  Created by Edwin Cardenas on 10/12/25.
//

import UIKit

protocol SettingsControllerDelegate: AnyObject {

    func settingsController(
        _ controller: SettingsController,
        wantsToUpdate user: User
    )

}

class SettingsController: UITableViewController {

    // MARK: Properties

    private var user: User

    weak var delegate: SettingsControllerDelegate?

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

    // MARK: - Initializers

    init(user: User) {
        self.user = user

        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        tableView.sectionHeaderTopPadding = 0
    }

}

// MARK: - Actions

extension SettingsController {

    @objc func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        view.endEditing(true)

        delegate?.settingsController(self, wantsToUpdate: user)
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
        return 1
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: NSStringFromClass(SettingsCell.self),
                for: indexPath
            ) as? SettingsCell
        else {
            fatalError("Could not dequeue SettingsCell.")
        }

        guard let section = SettingsSections(rawValue: indexPath.section) else {
            fatalError("Could not create SettingsSection from raw value.")
        }

        let viewModel = SettingsViewModel(user: user, section: section)

        cell.selectionStyle = .none
        cell.viewModel = viewModel
        cell.delegate = self

        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 40
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

// MARK: - SettingsCellDelegate

extension SettingsController: SettingsCellDelegate {

    func settingsCell(
        _ cell: SettingsCell,
        wantsToUpdateAgeRangeFor sender: UISlider
    ) {
        if sender === cell.minAgeSlider {
            user.minSeekingAge = Int(sender.value)
        } else {
            user.maxSeekingAge = Int(sender.value)
        }
    }

    func inputFieldDidEndEditing(
        with value: String,
        forSection section: SettingsSections
    ) {
        switch section {
        case .name:
            user.fullname = value
        case .profession:
            user.profession = value
        case .age:
            user.age = Int(value) ?? user.age
        case .bio:
            user.bio = value
        case .ageRange:
            break
        }
    }

}

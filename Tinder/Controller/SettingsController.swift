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

//
//  HelloViewController.swift
//  GitHubClient
//
//  Created by Павел on 09.10.2020.
//

import UIKit
import Kingfisher

class HelloViewController: UIViewController {
    
    private let helloLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    private let avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let searchLabel: UILabel = {
        let label = UILabel()
        label.text = "Search repository"
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    private let repositoryNameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "repository name"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGray2.cgColor
        textField.layer.cornerRadius = 5
        return textField
    }()
    private let languageTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "language"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGray2.cgColor
        textField.layer.cornerRadius = 5
        return textField
    }()
    private let segmentedControl: UISegmentedControl = {
        let items = ["ascended", "descended"]
        let sc = UISegmentedControl(items: items)
        sc.layer.cornerRadius = 5
        sc.addTarget(self, action: #selector(segmentedControlHandler(sender:)), for: .valueChanged)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    private let startSearchButton: UIButton = {
        let button = UIButton(type: .system)
        let title = "Start search"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 30, weight: .bold),
            .foregroundColor: UIColor.systemBlue
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(startSearchButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        addSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setupSubviews()
    }
    
    private func addSubviews() {
        [helloLabel,
         avatarView,
         searchLabel,
         repositoryNameTextField,
         languageTextField,
         segmentedControl,
         startSearchButton
        ].forEach {
            view.addSubview($0)
            turnOffAutoResisingMask($0)
        }
    }
    
    private func setupSubviews() {
        NSLayoutConstraint.activate([
            helloLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            helloLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            avatarView.topAnchor.constraint(equalTo: helloLabel.bottomAnchor, constant: 20),
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: view.bounds.width / 3),
            avatarView.heightAnchor.constraint(equalToConstant: view.bounds.width / 3),
            
            searchLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 40),
            searchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            repositoryNameTextField.topAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: 20),
            repositoryNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            repositoryNameTextField.widthAnchor.constraint(equalToConstant: view.bounds.width - 2 * 40),

            languageTextField.topAnchor.constraint(equalTo: repositoryNameTextField.bottomAnchor, constant: 12),
            languageTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            languageTextField.widthAnchor.constraint(equalToConstant: view.bounds.width - 2 * 40),
            
            segmentedControl.topAnchor.constraint(equalTo: languageTextField.bottomAnchor, constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalToConstant: view.bounds.width - 2 * 40),
            
            startSearchButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 40),
            startSearchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    @objc private func segmentedControlHandler(sender: UISegmentedControl) {
        
    }
    
    @objc private func startSearchButtonPressed() {
        
    }
    
    private func turnOffAutoResisingMask(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

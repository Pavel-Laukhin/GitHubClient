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
        imageView.backgroundColor = .systemTeal
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
    private let switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.isOn = false
        switcher.addTarget(self, action: #selector(switchHandler), for: .valueChanged)
        return switcher
    }()
    private let starsLabel: UILabel = {
        let label = UILabel()
        label.text = "Stars >"
        label.font = UIFont.systemFont(ofSize: 17)
        label.isEnabled = false
        return label
    }()
    private let starsNumberTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "0"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.cornerRadius = 5
        textField.keyboardType = .numberPad
        textField.isEnabled = false
        return textField
    }()
    private let segmentedControl: UISegmentedControl = {
        let items = ["ascended", "descended"]
        let sc = UISegmentedControl(items: items)
        sc.layer.cornerRadius = 5
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
         switcher,
         starsLabel,
         starsNumberTextField,
         segmentedControl,
         startSearchButton
        ].forEach {
            view.addSubview($0)
            turnOffAutoResisingMask($0)
        }
    }
    
    private func setupSubviews() {
        let avatarWidth = view.bounds.width / 3
        
        NSLayoutConstraint.activate([
            helloLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            helloLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            avatarView.topAnchor.constraint(equalTo: helloLabel.bottomAnchor, constant: 20),
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: avatarWidth),
            avatarView.heightAnchor.constraint(equalToConstant: avatarWidth),
            
            searchLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 40),
            searchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            repositoryNameTextField.topAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: 20),
            repositoryNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            repositoryNameTextField.widthAnchor.constraint(equalToConstant: view.bounds.width - 2 * 40),

            languageTextField.topAnchor.constraint(equalTo: repositoryNameTextField.bottomAnchor, constant: 12),
            languageTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            languageTextField.widthAnchor.constraint(equalToConstant: view.bounds.width - 2 * 40),
            
            switcher.leadingAnchor.constraint(equalTo: languageTextField.leadingAnchor),
            switcher.centerYAnchor.constraint(equalTo: starsNumberTextField.centerYAnchor),
            
            starsLabel.leadingAnchor.constraint(equalTo: switcher.trailingAnchor, constant: 15),
            starsLabel.centerYAnchor.constraint(equalTo: starsNumberTextField.centerYAnchor),

            
            starsNumberTextField.topAnchor.constraint(equalTo: languageTextField.bottomAnchor, constant: 15),
            starsNumberTextField.leadingAnchor.constraint(equalTo: starsLabel.trailingAnchor, constant: 15),
            
            segmentedControl.topAnchor.constraint(equalTo: starsNumberTextField.bottomAnchor, constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalToConstant: view.bounds.width - 2 * 40),
            
            startSearchButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 40),
            startSearchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        avatarView.layer.cornerRadius = avatarWidth / 2
    }
    
    @objc private func switchHandler() {
        switch switcher.isOn {
        case true:
            starsLabel.isEnabled = true
            starsNumberTextField.isEnabled = true
        case false:
            starsLabel.isEnabled = false
            starsNumberTextField.isEnabled = false
        }
    }
    
    @objc private func startSearchButtonPressed() {
        guard let searchString = repositoryNameTextField.text,
              let language = languageTextField.text
        else {
            return
        }
        let stars = switcher.isOn ? Int(starsNumberTextField.text ?? "0") : nil
        let queryEngine = QueryEngine(searchString: searchString, language: language, stars: stars)
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            queryEngine.order = "asc"
        case 1:
            queryEngine.order = "desc"
        default:
            fatalError("Index of segmented control is out of range!")
        }
        queryEngine.performSearchRepoRequest()
    }
    
    private func turnOffAutoResisingMask(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // Метод, который убирает клавиатуру после того, как закончилось редактирование
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

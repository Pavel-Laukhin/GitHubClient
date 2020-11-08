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
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    private let languageTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "language"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGray.cgColor
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
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        addSubviews()
        addTapGestureRecognizer()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setupSubviews()
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        turnOffAutoResisingMask(scrollView)
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
            scrollView.addSubview($0)
            turnOffAutoResisingMask($0)
        }
    }
    
    private func setupSubviews() {
        let avatarWidth = view.bounds.width / 3
        avatarView.layer.cornerRadius = avatarWidth / 2
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
            helloLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            helloLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            avatarView.topAnchor.constraint(equalTo: helloLabel.bottomAnchor, constant: 20),
            avatarView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: avatarWidth),
            avatarView.heightAnchor.constraint(equalToConstant: avatarWidth),
            
            searchLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 40),
            searchLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            repositoryNameTextField.topAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: 20),
            repositoryNameTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            repositoryNameTextField.widthAnchor.constraint(equalToConstant: view.bounds.width - 2 * 40),
            
            languageTextField.topAnchor.constraint(equalTo: repositoryNameTextField.bottomAnchor, constant: 12),
            languageTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            languageTextField.widthAnchor.constraint(equalToConstant: view.bounds.width - 2 * 40),
            
            switcher.leadingAnchor.constraint(equalTo: languageTextField.leadingAnchor),
            switcher.centerYAnchor.constraint(equalTo: starsNumberTextField.centerYAnchor),
            
            starsLabel.leadingAnchor.constraint(equalTo: switcher.trailingAnchor, constant: 15),
            starsLabel.centerYAnchor.constraint(equalTo: starsNumberTextField.centerYAnchor),
            
            
            starsNumberTextField.topAnchor.constraint(equalTo: languageTextField.bottomAnchor, constant: 15),
            starsNumberTextField.leadingAnchor.constraint(equalTo: starsLabel.trailingAnchor, constant: 15),
            
            segmentedControl.topAnchor.constraint(equalTo: starsNumberTextField.bottomAnchor, constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalToConstant: view.bounds.width - 2 * 40),
            
            startSearchButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 40),
            startSearchButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            startSearchButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
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
        startAnimating()
        
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
        
        queryEngine.performSearchRepoRequest { [weak self] repos in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.navigationController?.dismiss(animated: false, completion: nil)
                let resultTable = ResultTableViewController(repoArray: repos)
                self.navigationController?.pushViewController(resultTable, animated: true)
            }
        }
    }
    
    private func turnOffAutoResisingMask(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    private func tapGestureHandler() {
        [repositoryNameTextField,
         languageTextField,
         starsNumberTextField
        ].forEach { $0.resignFirstResponder() }
    }
    
    func startAnimating() {
        let activityVC = ActivityIndicatorViewController()
        activityVC.modalPresentationStyle = .overFullScreen
        navigationController?.present(activityVC, animated: false, completion: nil)
    }
    
    // MARK: Keyboard actions
    @objc fileprivate func handleKeyboardNotification(notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if notification.name == UIResponder.keyboardWillShowNotification {
            
            // Меняем размер контента у скролл вью:
            scrollView.contentInset.bottom = keyboardFrame.height
            
            // Меняем размер контента у скролл индикатора:
            scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.height
        }
        else {
            UIView.animate(withDuration: 0.2) {
                self.scrollView.contentInset = .zero
                self.scrollView.verticalScrollIndicatorInsets = .zero
            }
        }
    }
    
}

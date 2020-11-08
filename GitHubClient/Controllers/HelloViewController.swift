//
//  HelloViewController.swift
//  GitHubClient
//
//  Created by Павел on 09.10.2020.
//

import UIKit
import Kingfisher

class HelloViewController: UIViewController {
    
    private enum TextFieldTag: Int {
        case repository = 0
        case language
        
        init(tag: Int) {
            switch tag {
            case 0: self = .repository
            case 1: self = .language
            default:
                fatalError("Unknown tag: \(tag)")
            }
        }
    }
    
    private let helloLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.numberOfLines = 2
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
    
    private lazy var repositoryNameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "repository name"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.cornerRadius = 5
        textField.delegate = self
        textField.tag = TextFieldTag.repository.rawValue
        return textField
    }()
    
    private lazy var languageTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "language"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.delegate = self
        textField.tag = TextFieldTag.language.rawValue
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
    
    private lazy var scrollView: AppScrollView = {
            let scrollView = AppScrollView()
            return scrollView
        }()
    
    // MARK: - Life cycle
    init(user: User) {
        if let url = URL(string: user.avatarURL) {
            avatarView.kf.setImage(with: url)
        }
        
        if let name = user.name {
            helloLabel.text = "Hello, \(name)"
        } else {
            helloLabel.text = "Hello, \(user.userName)!"
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        addSubviews()
        makeNavBarOpaque()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: Keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.toAutoLayout()
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
            $0.toAutoLayout()
        }
    }
    
    private func setupSubviews() {
        let avatarWidth = view.bounds.width / 2
        avatarView.layer.cornerRadius = avatarWidth / 2
        avatarView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
            helloLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            helloLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            avatarView.topAnchor.constraint(equalTo: helloLabel.bottomAnchor, constant: 20),
            avatarView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: avatarWidth),
            avatarView.heightAnchor.constraint(equalToConstant: avatarWidth),
            
            searchLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 24),
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
            
            startSearchButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            startSearchButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            startSearchButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func makeNavBarOpaque() {
        navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: - Actions
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
        ActivityIndicatorViewController.startAnimating(in: self)
        
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
                ActivityIndicatorViewController.stopAnimating(in: self)
                let resultTable = ResultTableViewController(repoArray: repos)
                self.navigationController?.pushViewController(resultTable, animated: true)
            }
        }
    }
    
    // MARK: - Keyboard actions
    @objc fileprivate func handleKeyboardNotification(notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if notification.name == UIResponder.keyboardWillShowNotification {
            
            // Меняем размер контента у скролл вью:
            scrollView.contentInset.bottom = keyboardFrame.height
            
            // Меняем размер контента у скролл индикатора:
            scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.height
            
            // Конвертируем фрейм клавиатуры в систему координат скролл вью:
            let convertedKeyboardFrame = self.scrollView.convert(keyboardFrame, from: nil)
            
            // Считаем размер, на который нужно подвинуть содержимое скролл вью, в зависимости от того, пересекает ли клавиатура фрейм сегментед контрола (чтобы сегментед контролл был видимым).
            // Контент должен отъехать на разницу координат верхней точки клавиатуры и нижней точки сегментед контрола. Добавим еще отступ 8 поинтов, чтобы сегментед контрол не прилипал к клавиатуре.
            let keyboardOffset = (convertedKeyboardFrame.intersects(segmentedControl.frame)) ? segmentedControl.frame.maxY - convertedKeyboardFrame.minY + 8 : 0
            
            // Eсли уже анимированно скрольнули вверх, то не нужно делать это еще раз
            if scrollView.contentOffset.y > 0 {
                return
            }
            
            UIView.animate(withDuration: 0.2) {
                self.scrollView.contentOffset.y = keyboardOffset
            }
        }
        else {
            scrollView.contentInset = .zero
            scrollView.verticalScrollIndicatorInsets = .zero
            scrollView.contentOffset.y = .zero
        }
    }
    
}

// MARK: UITextFieldDelegate
extension HelloViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch TextFieldTag(tag: textField.tag) {
        case .repository:
            languageTextField.becomeFirstResponder()
        case .language:
            scrollView.endEditing(true)
        }
        
        return true
    }
}

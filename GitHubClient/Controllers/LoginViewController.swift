//
//  LoginViewController.swift
//  GitHubClient
//
//  Created by Павел on 09.10.2020.
//

import UIKit
import Kingfisher

class LoginViewController: UIViewController {

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var scrollView: AppScrollView!
    
    private let queryEngine = QueryEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "GitHub.com"
        addGitHubLogo()
        makeButtonRounded()
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

    private func addGitHubLogo() {
        let url = URL(string: "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png")
        logoView.kf.setImage(with: url)
    }
    
    private func makeButtonRounded() {
        signInButton.layer.cornerRadius = 6
    }

    @IBAction func signInButtonPressed(_ sender: UIButton) {
        let keychain = Keychain()
        
        if let currentUser = User.currentUser,
           let token = keychain.readPassword(account: currentUser.userName) {
            print("The token was successfully retrieved! :]")
            HelloViewController.showSelf(using: token)
        } else {
            print("The token wasn't successfully retrieved! :[")
            ActivityIndicatorViewController.startAnimating(in: self)
            queryEngine.openPageToLogin()
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
            let keyboardOffset = (convertedKeyboardFrame.intersects(signInButton.frame)) ? signInButton.frame.maxY - convertedKeyboardFrame.minY + 8 : 0
            
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


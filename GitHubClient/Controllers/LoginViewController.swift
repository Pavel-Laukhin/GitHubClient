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
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let queryEngine = QueryEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "GitHub.com"
        addGitHubLogo()
        makeButtonRounded()
    }

    private func addGitHubLogo() {
        // Установим логотип GitHub:
        let url = URL(string: "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png")
        logoView.kf.setImage(with: url)
    }
    
    private func makeButtonRounded() {
        signInButton.layer.cornerRadius = 6
    }

    @IBAction func signInButtonPressed(_ sender: UIButton) {
        ActivityIndicatorViewController.startAnimating(in: self)
        guard let login = loginTextField.text,
              let password = passwordTextField.text else {
            let ac = UIAlertController(title: "Fill the gaps", message: "Login or password is empty", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            ac.addAction(ok)
            present(ac, animated: true, completion: nil)
            print(type(of: self), #function, "Login or password is empty!")
            return
        }
        queryEngine.performLoginRequest(login: login, password: password) { [weak self] user in
            guard let self = self else {
                print(#function, "Can't return user")
                return
            }
            DispatchQueue.main.async {
                let vc = HelloViewController(user: user)
                self.navigationController?.pushViewController(vc, animated: true)
                ActivityIndicatorViewController.stopAnimating(in: self)
            }
        }
    }
    
    // Метод, который убирает клавиатуру после того, как закончилось редактирование
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


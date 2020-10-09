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
        let vc = HelloViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


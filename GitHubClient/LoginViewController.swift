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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "GitHub.com"
        addGitHubLogo()
    }

    private func addGitHubLogo() {
        // Установим логотип GitHub:
        let url = URL(string: "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png")
        logoView.kf.setImage(with: url)
    }

}


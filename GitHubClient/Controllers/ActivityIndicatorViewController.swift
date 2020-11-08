//
//  ActivityIndicatorViewController.swift
//  GitHubClient
//
//  Created by Павел on 18.10.2020.
//

import UIKit

class ActivityIndicatorViewController: UIViewController {
        
    private var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        view.alpha = 0.7
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.color = .white
        activityIndicator.startAnimating()
    }
    
    /// Презентует модально поверх всего экрана полупрозрачный вью контроллер с работающим активити индикатором:
    class func startAnimating(in viewController: UIViewController) {
        let activityVC = ActivityIndicatorViewController()
        activityVC.modalPresentationStyle = .overFullScreen
        viewController.navigationController?.present(activityVC, animated: false, completion: nil)
    }
    
    class func stopAnimating(in viewController: UIViewController) {
        if viewController.navigationController?.presentedViewController is ActivityIndicatorViewController {
            viewController.navigationController?.dismiss(animated: false, completion: nil)
        }
    }
    
}

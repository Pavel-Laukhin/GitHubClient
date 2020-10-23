//
//  AppScrollView.swift
//  GitHubClient
//
//  Created by Павел on 23.10.2020.
//

import UIKit

final class AppScrollView: UIScrollView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        endEditing(true)
    }
}

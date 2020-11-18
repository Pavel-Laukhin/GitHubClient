//
//  SceneDelegate.swift
//  GitHubClient
//
//  Created by Павел on 09.10.2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private let keychain = Keychain()
    private let queryEngine = QueryEngine()
    
    // Получаем временный код с гитхаба
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        // Getting a temporary code.
        guard let url = URLContexts.first?.url,
              let receivedParameters = url.params(),
              let code = receivedParameters["code"] as? String else { return }
        
        let group = DispatchGroup()
        var token: String?
        
        group.enter()
        queryEngine.performTokenRequest(temporaryCode: code) { receivedToken in
            token = receivedToken
            group.leave()
        }
        
        // Waiting to receive a token.
        group.wait()
        
        // Displaying the HelloViewController for the current user by using the received token.
        guard token != nil else { return }
        HelloViewController.showSelf(using: token!)
    }
    
}


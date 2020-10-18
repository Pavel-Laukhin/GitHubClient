//
//  Repo.swift
//  GitHubClient
//
//  Created by Павел on 16.10.2020.
//

import UIKit

struct Repo {
    
    let title: String
    let details: String
    let url: String
    let user: String
    let avatarURL: String
    
    init?(json: Dictionary<String, Any>) {
        guard let title = json["name"] as? String,
              let details = json["description"] as? String,
              let url = json["url"] as? String,
              let owner = json["owner"] as? [String: Any],
              let user = owner["login"] as? String,
              let avatarURL = owner["avatar_url"] as? String
        else {
            print("Repo initialization error")
            return nil
        }
        self.title = title
        self.details = details
        self.url = url
        self.user = user
        self.avatarURL = avatarURL
    }
    
}

//
//  Repos.swift
//  GitHubClient
//
//  Created by Павел on 16.10.2020.
//

import UIKit

struct Repos: Codable {
    
    let totalCount: Int
    let items: [Repo]
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }

    struct Repo: Codable {
        let title: String
        let details: String?
        let url: String
        let owner: Owner
        
        private enum CodingKeys: String, CodingKey {
            case title = "name"
            case details = "description"
            case url = "html_url"
            case owner
        }
        
        struct Owner: Codable {
            let user: String
            let avatarURL: String
            
            private enum CodingKeys: String, CodingKey {
                case user = "login"
                case avatarURL = "avatar_url"
            }
        }
    }
    
}

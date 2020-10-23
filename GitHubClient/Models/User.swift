//
//  User.swift
//  GitHubClient
//
//  Created by Павел on 23.10.2020.
//

import Foundation

struct User: Codable {

    var name: String?
    var userName: String
    var avatarURL: String

    private enum CodingKeys: String, CodingKey {
        case userName = "login"
        case avatarURL = "avatar_url"
    }

}

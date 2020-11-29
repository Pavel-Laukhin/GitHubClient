//
//  URL Extension.swift
//  GitHubClient
//
//  Created by Павел on 15.11.2020.
//

import UIKit

extension URL {
    
    /// Метод, возвращающий компоненты запроса из URL-адреса в виде словаря [String: Any]. Возвращает nil в случае неудачи.
    func params() -> [String: Any]? {
        var dict = [String: Any]()
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return nil
        }
        guard let queryItems = components.queryItems else {
            return nil
        }
        for item in queryItems {
            dict[item.name] = item.value
        }
        return dict
    }
    
}

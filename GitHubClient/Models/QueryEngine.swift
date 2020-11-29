//
//  QueryEngine.swift
//  GitHubClient
//
//  Created by Павел on 09.10.2020.
//

import UIKit

class QueryEngine: NSObject {
    
    private let scheme = "https"
    private let host = "api.github.com"
    private let auth = "Authorization"
    
    private let hostPath = "https://api.github.com"
    private let repoPath = "/repositories"
    private let emailPath = "/user/emails"
    private let searchRepoPath = "/search/repositories"
    private let userPath = "https://api.github.com/user"

    private let defaultHeaders = [
        "Content-Type" : "application/json",
        "Accept" : "application/vnd.github.v3+json"
    ]
    
    private let sharedSession = URLSession.shared
    
    private let searchString: String
    private let language: String
    private var stars: Int?
    private var order: String
    
    // MARK: For new OAuth Authorization.
    private let clientId = "79bc44b8862030cb64e4"
    private let clientSecret = "8cb50c9f9683e0d850fb242c713ba188ffecf079"
    private let identityPath = "/login/oauth/authorize"
    private let loginHost = "github.com"
    private let loginTokenPath = "/login/oauth/access_token"
    private let userTokenPath = "/user"
    
    override init() {
        searchString = ""
        language = ""
        order = "desc"
    }
    
    init(searchString: String, language: String, order: String, stars: Int?) {
        self.searchString = searchString
        self.language = language
        self.order = order
        if let stars = stars {
            self.stars = stars
        }
    }
    
    private func searchRepositoriesRequest() -> URLRequest? {
        // 9
        var urlComponents = URLComponents()
        // 10
        urlComponents.scheme = scheme
        // 11
        urlComponents.host = host
        // 12
        urlComponents.path = searchRepoPath
        // 13
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: "\(searchString)+language:\(language)" + (stars != nil ? "+stars:>\(stars ?? 0)" : "")),
            URLQueryItem(name: "sort", value: "stars"),
            URLQueryItem(name: "order", value: order)
        ]
        // 14
        guard let url = urlComponents.url else {
            return nil
        }
        print("search request url:\(url)")
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        return request
    }
    
    func performSearchRepoRequest(handler: @escaping ([Repos.Repo], Int) -> Void) {
        guard let urlRequest = searchRepositoriesRequest() else {
            print("url request error")
            return
        }
        
        let dataTask = sharedSession.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("http status code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("no data received")
                return
            }
            
            let decoder = JSONDecoder()
            
            // Создаем массив экземпляров Repo
            if let repos = try? decoder.decode(Repos.self, from: data)   {
                
                // Работаем с полученным массивом
                handler(repos.items, repos.totalCount)
            }
        }
        
        dataTask.resume()
        return
    }
    
    // MARK: New OAuth Authorization
    
    /// Method for opening a page in Safari for authorization on the github.com
    func openPageToLogin() {
        guard let url = createLoginURL() else { return }
        UIApplication.shared.open(url)
    }
    
    /// Method for creating the URL with necessary componets for futher authorization on the github.com
    private func createLoginURL() -> URL? {
        let urlComponents: URLComponents = {
            var urlComponents = URLComponents()
            urlComponents.scheme = scheme
            urlComponents.host = loginHost
            urlComponents.path = identityPath
            urlComponents.queryItems = [URLQueryItem(name: "client_id", value: clientId)]
            return urlComponents
        }()
        
        guard let url = urlComponents.url else { return nil }
        return url
    }
    
    /// Method for making URLRequest with necessary componets for futher token getting from the github.com
    private func tokenRequest(temporaryCode: String) ->
    URLRequest? {
        let urlComponents: URLComponents = {
            var urlComponents = URLComponents()
            urlComponents.scheme = scheme
            urlComponents.host = loginHost
            urlComponents.path = loginTokenPath
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: clientId),
                URLQueryItem(name: "client_secret", value: clientSecret),
                URLQueryItem(name: "code", value: temporaryCode)]
            return urlComponents
        }()
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Accept" : "application/json"]
        
        return request
    }
    
    /// Method for getting token from the github.com
    func performTokenRequest(temporaryCode: String, completion: @escaping (String) -> Void ) {
        
        guard let request = tokenRequest(temporaryCode: temporaryCode) else { return }
                
        let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("http status code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("no data received")
                return
            }
            
            if let tokenString = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let token = tokenString["access_token"] as? String {
                completion(token)
            }
        }
        
        dataTask.resume()
    }
    
    /// Method for getting information about the current user from  api.github.com using token
    func getCurrentUserData(token: String, completion: @escaping (Data?) -> Void) {
        let urlComponents: URLComponents = {
            var urlComponents = URLComponents()
            urlComponents.scheme = scheme
            urlComponents.host = host
            urlComponents.path = userTokenPath
            return urlComponents
        }()
        
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
        let urlSession = URLSession(configuration: .default)
        let dataTask = urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("http status code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("no data received")
                return
            }
            completion(data)
        }
        
        dataTask.resume()
    }
    
}

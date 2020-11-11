//
//  QueryEngine.swift
//  GitHubClient
//
//  Created by Павел on 09.10.2020.
//

import Foundation

class QueryEngine: NSObject {
    
    let scheme = "https"
    let host = "api.github.com"
    let auth = "Authorization"
    
    let hostPath = "https://api.github.com"
    let repoPath = "/repositories"
    let emailPath = "/user/emails"
    let searchRepoPath = "/search/repositories"
    let userPath = "https://api.github.com/user"

    let defaultHeaders = [
        "Content-Type" : "application/json",
        "Accept" : "application/vnd.github.v3+json"
    ]
    
    let sharedSession = URLSession.shared
    
    let searchString: String
    let language: String
    var stars: Int?
    var order: String = "desc"
    
    override init() {
        searchString = ""
        language = ""
    }
    
    init(searchString: String, language: String, stars: Int?) {
        self.searchString = searchString
        self.language = language
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
    
    func performSearchRepoRequest(handler: @escaping ([Repos.Repo]) -> Void) {
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
                handler(repos.items)
            }
        }
        
        dataTask.resume()
        return
    }
    
    private func loginRequest(login: String, password: String) -> URLRequest? {
       
        let loginString = "\(login):\(password)"
        
        guard let loginData = loginString.data(using: .utf8),
              let url = URL(string: userPath) else { return nil }
        
        let base64LoginString = loginData.base64EncodedString()
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: auth)
        
        return request
    }
    
    func performLoginRequest(login: String, password: String, handler: @escaping (User) -> Void) {
        
        guard let urlRequest = loginRequest(login: login, password: password) else {
            print(type(of: self), #function, "Can't make urlRequest")
            return
        }

        // Setup Data Task
        let dataTask = sharedSession.dataTask(with: urlRequest) { (data, response, error) in

            if let error = error {
                print(type(of: self), #function, error.localizedDescription)
            }

            if let httpResponse = response as? HTTPURLResponse {
                print(type(of: self), #function, "http status code: \(httpResponse.statusCode)")
            }

            guard let data = data else {
                print(type(of: self), #function, "No data received")
                return
            }
            
            let decoder = JSONDecoder()
            
            guard let user = try? decoder.decode(User.self, from: data) else {
                print(type(of: self), #function, "Can't make user")
                return
            }
            
            print(type(of: self), #function, user)
            handler(user)
        }

        dataTask.resume()
        return
    }
    
}

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

    let defaultHeaders = [
        "Content-Type" : "application/json",
        "Accept" : "application/vnd.github.v3+json"
    ]
    
    let sharedSession = URLSession.shared
    
    let searchString: String
    let language: String
    var stars: Int?
    var order: String = "desc"
    
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
    
}

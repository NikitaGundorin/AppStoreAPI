//
//  Service.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 29.06.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

class Service {
    static let shared = Service()
    
    private init() {}
    
    func fetchApps(searchTerm: String, completion: @escaping ([Result], Error?) -> ()) {
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchTerm)&entity=software") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch apps: ", error)
                completion([], error)
                return
            }
            
            guard let data = data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completion(searchResult.results, nil)
            } catch let jsonError {
                print("Failed to decode JSON: ", jsonError)
                completion([], jsonError)
            }
            
        }.resume()
    }
}

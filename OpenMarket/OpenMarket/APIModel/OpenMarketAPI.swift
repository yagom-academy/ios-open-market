//
//  OpenMarketAPI.swift
//  OpenMarket
//
//  Created by 기원우 on 2021/05/19.
//

import Foundation

class OpenMarketAPI {
    let session: URLSession
    let baseUrl: String = "https://camp-open-market-2.herokuapp.com/"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getItemList(completion: @escaping ([Item]) -> Void) {
        
        let path: String = "/items/1"
        guard let url = URL(string: baseUrl + path) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task: URLSessionDataTask = session
            .dataTask(with: request) { data, urlResponse, error in
            
            guard let response = urlResponse as? HTTPURLResponse,
                  (200...399).contains(response.statusCode) else {
                completion([])
                return
            }
            
            if let data = data,
               let itemResponse = try? JSONDecoder().decode(ItemListSearchResponse.self, from: data) {
                completion(itemResponse.items)
                return
            }
            
            completion([])
        }
        
        task.resume()
    }
    
    
}

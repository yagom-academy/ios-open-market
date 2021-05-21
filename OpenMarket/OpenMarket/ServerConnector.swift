//
//  URLSession.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/05/20.
//

import Foundation

struct servedItems {
    static var items: Items!
}

struct ServerConnector {
    let domain: String
    let url: URL
    var urlRequest: URLRequest
    
    init(domain: String) {
        self.domain = domain
        self.url = URL(string: domain)!
        self.urlRequest = URLRequest(url: url)
    }
    
    mutating func getServersData() {
        self.urlRequest.httpMethod = "Get"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("에러")
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("200번대 상태가 아닙니다 !")
                return
            }
            
            if let mimeType = httpResponse.mimeType,
               mimeType == "application/json",
               let data = data,
               let convertedData = try? JSONDecoder().decode(Items.self, from: data) {
                servedItems.items = convertedData
            }
        }
        task.resume()
    }

    func postClientsData() {}
    
    func patchSeversData() {}
    
    func deleteServersData() {}
} 

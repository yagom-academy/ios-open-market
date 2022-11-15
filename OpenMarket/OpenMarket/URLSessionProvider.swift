//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/15.
//

import Foundation

class MarketURLSessionProvider {
    let session: URLSession = URLSession(configuration: .default)
    let baseUrl: String = "https://openmarket.yagom-academy.kr"
    var market: Market?
    
    func fetchData() {
        guard let url = URL(string: baseUrl) else { return }
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard error == nil,
                  let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else { return }
            
            guard let decodedData = JSONDecoder.decodeFromServer(type: Market.self,
                                                                 from: data) else { return }
            print(decodedData)
        }
        
        dataTask.resume()
    }
}

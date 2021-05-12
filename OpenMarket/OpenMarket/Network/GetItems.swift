//
//  GetItems.swift
//  OpenMarket
//
//  Created by Fezz, Tak on 2021/05/12.
//

import Foundation

final class GetItems {
    private let page: UInt
    
    init(page: UInt) {
        self.page = page
    }
    
    func network(completion: @escaping (MarketItems?) -> ()) {
        guard let MarketUrl = combineURL() else {
            return
        }
        var request = URLRequest(url: MarketUrl)
        request.httpMethod = MarketAPIType.get.description
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                NSLog("GET 통신 오류 \(error?.localizedDescription ?? "")")
                completion(nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299) ~= response.statusCode else {
                NSLog("HTTP Status 오류")
                completion(nil)
                return
            }
            
            guard let data = data else {
                NSLog("Data 오류")
                completion(nil)
                return
            }
            
            do {
                let jsonDecode = try JSONDecoder().decode(MarketItems.self, from: data)
                completion(jsonDecode)
            } catch {
                completion(nil)
                NSLog("JSON decode 오류")
            }
        }.resume()
    }
    
    private func combineURL() -> URL? {
        return URL(string: MarketAPI.api + MarketAPIPath.items.description + "\(page)")
    }
}

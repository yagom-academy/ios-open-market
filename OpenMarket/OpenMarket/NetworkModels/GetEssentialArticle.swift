//
//  GetEssentilaArticle.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/14.
//

import Foundation

class GetEssentialArticle {
    
    func getParsing() {
        guard let baseUrl = URL(string: "https://camp-open-market-2.herokuapp.com/items/1") else { return }

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let dataTask = session.dataTask(with: baseUrl) { (data, response, error) in
            guard error == nil else { return }

            if self.checkResponseCode(response: response) {
                guard let resultData = data else { return }
                self.decodeData(data: resultData)
            } else { return }
        }
        dataTask.resume()
    }
    
    func checkResponseCode(response: URLResponse?) -> Bool {
        guard let successResponse = (response as? HTTPURLResponse)?.statusCode else { return false }
        
        if successResponse >= 200 && successResponse < 300 { return true }
        
        return false
    }
    
    func decodeData(data: Data) {
        
        do {
            let decoder = JSONDecoder()
            let parsingData = try decoder.decode(EntireArticle.self, from: data)

            let items = parsingData.items

            print("\(items.first?.title)")
        } catch {
            print("에러")
        }
        
    }
    
}

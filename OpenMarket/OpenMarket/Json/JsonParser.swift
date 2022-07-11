//
//  JsonParser.swift
//  OpenMarket
//
//  Created by Baek on 2022/07/11.
//

import Foundation

struct JsonParser {
    func fetch(){
        if let url = URL(string: "https://market-training.yagom-academy.kr/api/products/3541") {
            var request = URLRequest.init(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                
                let decoder = JSONDecoder()
                if let json = try? decoder.decode(Page.self, from: data) {
                    print(json.bargainPrice)
                }
            }.resume()
        }
    }
}

//
//  JsonParer.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/12.
//

import Foundation

struct JsonParser {
    let url: String = "https://market-training.yagom-academy.kr/api/products/"
    
    func fetch(from url: String) {
        var request = URLRequest.init(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            guard let data = data, error == nil else {
                return
            }
            var result: Network?
            
            do {
                result = try JSONDecoder().decode(Network.self, from: data)
            }
            catch {
                print("fail error: \(error)")
            }
            guard let json = result else {
                return
            }
            print(json)
        }
        task.resume()
    }
}

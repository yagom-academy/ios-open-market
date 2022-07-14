//
//  DataManager.swift
//  OpenMarket
//
//  Created by minsson on 2022/07/14.
//

import UIKit

struct DataManager {
    static let openMarketAPIURL = "https://market-training.yagom-academy.kr/api/"
    
    static func performRequestToAPI(with request: String, completion: @escaping ((Data) -> Void)) {
        let requestURL = DataManager.openMarketAPIURL + request
        
        guard let url = URL(string: requestURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            completion(data)
        }
        task.resume()
    }
        let jsonDecoder: JSONDecoder = JSONDecoder()
        let targetType = type(of: target)
        
        guard let dataAsset: NSDataAsset = NSDataAsset.init(name: fileName) else {
            return nil
        }

        do {
            let data = try jsonDecoder.decode(targetType.self, from: dataAsset.data)
            return data
        } catch {
            return nil
        }
    }
}



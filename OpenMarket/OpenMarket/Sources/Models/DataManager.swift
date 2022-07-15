//
//  DataManager.swift
//  OpenMarket
//
//  Created by minsson, yeton on 2022/07/14.
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
            
            guard isValidResponse(response) else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            completion(data)
        }
        task.resume()
    }
    
    private static func isValidResponse(_ response: URLResponse?) -> Bool {
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
                  return false
              }
        
        return true
    }
    
    static func makeDataFrom(fileName: String) -> Data? {
        guard let dataAsset: NSDataAsset = NSDataAsset.init(name: fileName) else {
            return nil
        }
        
        return dataAsset.data
    }
    
    static func parse<T: Decodable>(_ data: Data?, into target: T) -> T? {
        let jsonDecoder: JSONDecoder = JSONDecoder()
        let targetType = type(of: target)
        
        guard let data = data else {
            return nil
        }
        
        do {
            let decodedData = try jsonDecoder.decode(targetType.self, from: data)
            return decodedData
        } catch {
            return nil
        }
    }
}



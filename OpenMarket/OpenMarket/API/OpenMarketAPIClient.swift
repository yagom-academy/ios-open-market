//
//  OpenMarketAPIClient.swift
//  OpenMarket
//
//  Created by Kyungmin Lee on 2021/01/27.
//

import UIKit

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
extension URLSession: URLSessionProtocol { }

enum OpenMarketAPI {
    case requestMarketPage
    case registerMarketItem
    case requestMarketItem
    case modifyMarketItem
    case deleteMarketItem
    
    static let baseURL = "https://camp-open-market.herokuapp.com/"
    var path: String {
        switch self {
        case .requestMarketPage:
            return "items/"
        case .registerMarketItem:
            return "item"
        case .requestMarketItem:
            return "item/"
        case .modifyMarketItem:
            return "item/"
        case .deleteMarketItem:
            return "item/"
        }
    }
    var url: URL? {
        return URL(string: OpenMarketAPI.baseURL + path)
    }
    var sampleData: Data {
        switch self {
        case .requestMarketPage:
            break
        case .registerMarketItem:
            break
        case .requestMarketItem:
            return NSDataAsset(name: "item")!.data
        case .modifyMarketItem:
            break
        case .deleteMarketItem:
            break
        }
        return NSDataAsset(name: "item")!.data
    }
}

enum OpenMarketAPIError: Error {
    case invalidURL
    case requestFailed
    case networkError
    case invalidData
}

class OpenMarketAPIClient {
    let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func requestMarketItem(id: Int, completion: @escaping (Result<MarketItem, OpenMarketAPIError>) -> Void) {
        guard let url = OpenMarketAPI.requestMarketItem.url?.appendingPathComponent("\(id)") else {
            completion(.failure(OpenMarketAPIError.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        let task = urlSession.dataTask(with: request) { data, urlResponse, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.requestFailed))
                return
            }
            guard let response = urlResponse as? HTTPURLResponse, (200...399).contains(response.statusCode) else {
                completion(.failure(OpenMarketAPIError.networkError))
                return
            }
            if let data = data,
               let marketItem = try? JSONDecoder().decode(MarketItem.self, from: data) {
                completion(.success(marketItem))
                return
            }
            completion(.failure(OpenMarketAPIError.invalidData))
        }
        task.resume()
    }
}

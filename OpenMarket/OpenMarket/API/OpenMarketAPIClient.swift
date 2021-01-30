//
//  OpenMarketAPIClient.swift
//  OpenMarket
//
//  Created by Kyungmin Lee on 2021/01/27.
//

import UIKit

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
            return NSDataAsset(name: "items")!.data
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
}

class OpenMarketAPIClient {
    let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func requestMarketItem(id: Int, completionHandler: @escaping (Result<MarketItem, OpenMarketAPIError>) -> Void) {
        guard let url = OpenMarketAPI.requestMarketItem.url?.appendingPathComponent("\(id)") else {
            completionHandler(.failure(.invalidURL))
            return
        }
        let requestData = RequestData<MarketItem>(url: url)
        urlSession.startDataTask(requestData) { (marketItem, error) in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(.failure(.requestFailed))
                return
            }
            if let marketItem = marketItem {
                completionHandler(.success(marketItem))
            } else {
                completionHandler(.failure(.networkError))
            }
        }
    }
    
    func registerMarketItme(_ postMarketItem: PostMarketItem, completionHandler: @escaping (Result<MarketItem, OpenMarketAPIError>) -> Void) {
        guard let url = OpenMarketAPI.registerMarketItem.url else {
            completionHandler(.failure(.invalidURL))
            return
        }
        let requestData = RequestData<MarketItem>(url: url, httpMethod: .post(postMarketItem))
        urlSession.startDataTask(requestData) { (marketItem, error) in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(.failure(.requestFailed))
                return
            }
            if let marketItem = marketItem {
                completionHandler(.success(marketItem))
            } else {
                completionHandler(.failure(.networkError))
            }
        }
    }
    
    func requestMarketPage(pageNumber: Int, completionHandler: @escaping (Result<MarketPage, OpenMarketAPIError>) -> Void) {
        guard let url = OpenMarketAPI.requestMarketPage.url?.appendingPathComponent("\(pageNumber)") else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        let requestData = RequestData<MarketPage>(url: url)
        urlSession.startDataTask(requestData) { (marketPage, error) in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(.failure(.requestFailed))
                return
            }
            if let marketPage = marketPage {
                completionHandler(.success(marketPage))
            } else {
                completionHandler(.failure(.networkError))
            }
        }
    }
}

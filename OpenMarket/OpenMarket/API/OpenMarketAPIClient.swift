//
//  OpenMarketAPIClient.swift
//  OpenMarket
//
//  Created by Kyungmin Lee on 2021/01/27.
//

import UIKit

enum OpenMarketAPI {
    case getMarketPage
    case postMarketItem
    case getMarketItem
    case patchMarketItem(id: Int)
    case deleteMarketItem(id: Int)
    
    static let baseURL = "https://camp-open-market.herokuapp.com/"
    var path: String {
        switch self {
        case .getMarketPage:
            return "items/"
        case .postMarketItem:
            return "item"
        case .getMarketItem:
            return "item/"
        case .patchMarketItem(let id), .deleteMarketItem(let id):
            return "item/\(id)"
        }
    }
    var url: URL? {
        return URL(string: OpenMarketAPI.baseURL + path)
    }
    var sampleData: Data {
        switch self {
        case .getMarketPage:
            return NSDataAsset(name: "items")!.data
        case .postMarketItem, .getMarketItem, .patchMarketItem:
            return NSDataAsset(name: "item")!.data
        case .deleteMarketItem:
            return NSDataAsset(name: "id")!.data
        }
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
    
    func getMarketPage(pageNumber: Int, completionHandler: @escaping (Result<MarketPage, OpenMarketAPIError>) -> Void) {
        guard let url = OpenMarketAPI.getMarketPage.url?.appendingPathComponent("\(pageNumber)") else {
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
    
    func postMarketIem(_ marketItemForPost: MarketItemForPost, completionHandler: @escaping (Result<MarketItem, OpenMarketAPIError>) -> Void) {
        guard let url = OpenMarketAPI.postMarketItem.url else {
            completionHandler(.failure(.invalidURL))
            return
        }
        let requestData = RequestData<MarketItem>(url: url, httpMethod: .post(marketItemForPost))
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
    
    func getMarketItem(id: Int, completionHandler: @escaping (Result<MarketItem, OpenMarketAPIError>) -> Void) {
        guard let url = OpenMarketAPI.getMarketItem.url?.appendingPathComponent("\(id)") else {
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
    
    func patchMarketIem(id: Int, _ marketItemForPatch: MarketItemForPatch, completionHandler: @escaping (Result<MarketItem, OpenMarketAPIError>) -> Void) {
        guard let url = OpenMarketAPI.patchMarketItem(id: id).url else {
            completionHandler(.failure(.invalidURL))
            return
        }
        let requestData = RequestData<MarketItem>(url: url, httpMethod: .patch(marketItemForPatch))
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
    
    func deleteMarketIem(id: Int, _ marketItemForDelete: MarketItemForDelete, completionHandler: @escaping (Result<MarketItem, OpenMarketAPIError>) -> Void) {
        guard let url = OpenMarketAPI.deleteMarketItem(id: id).url else {
            completionHandler(.failure(.invalidURL))
            return
        }
        let requestData = RequestData<MarketItem>(url: url, httpMethod: .delete(marketItemForDelete))
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
}

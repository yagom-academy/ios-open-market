//
//  OpenMarketAPIClient.swift
//  OpenMarket
//
//  Created by Kyungmin Lee on 2021/01/27.
//

import UIKit

class OpenMarketAPIClient {
    let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func getMarketPage(pageNumber: Int, completionHandler: @escaping (Result<MarketPage, OpenMarketAPIError>) -> Void) {
        guard let url = OpenMarketAPIConfiguration.getMarketPage(pageNumber: pageNumber).url else {
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
        guard let url = OpenMarketAPIConfiguration.postMarketItem.url else {
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
        guard let url = OpenMarketAPIConfiguration.getMarketItem(id: id).url else {
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
    
    func patchMarketItem(id: Int, _ marketItemForPatch: MarketItemForPatch, completionHandler: @escaping (Result<MarketItem, OpenMarketAPIError>) -> Void) {
        guard let url = OpenMarketAPIConfiguration.patchMarketItem(id: id).url else {
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
    
    func deleteMarketItem(id: Int, _ marketItemForDelete: MarketItemForDelete, completionHandler: @escaping (Result<MarketItem, OpenMarketAPIError>) -> Void) {
        guard let url = OpenMarketAPIConfiguration.deleteMarketItem(id: id).url else {
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

//
//  OpenMarketService.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/25.
//

import Foundation

class OpenMarketService {
    private let sessionManager: SessionManagerProtocol

    init(sessionManager: SessionManagerProtocol = SessionManager.shared) {
        self.sessionManager = sessionManager
    }

    func getPage(id: Int, completionHandler: @escaping (Result<MarketPage, OpenMarketError>) -> Void) {
        sessionManager.request(method: .get, path: .page(id: id)) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(MarketPage.self, from: data) else {
                    return completionHandler(.failure(.invalidData))
                }
                completionHandler(.success(decodedData))
            }
        }
    }

    func getItem(id: Int, completionHandler: @escaping (Result<MarketItem, OpenMarketError>) -> Void) {
        sessionManager.request(method: .get, path: .item(id: id)) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(MarketItem.self, from: data) else {
                    return completionHandler(.failure(.invalidData))
                }
                completionHandler(.success(decodedData))
            }
        }
    }

    func postItem(data: PostingItem, completionHandler: @escaping (Result<MarketItem, OpenMarketError>) -> Void) {
        sessionManager.request(method: .post, path: .item(), data: data) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(MarketItem.self, from: data) else {
                    return completionHandler(.failure(.invalidData))
                }
                completionHandler(.success(decodedData))
            }
        }
    }

    func patchItem(id: Int, data: PatchingItem, completionHandler: @escaping (Result<MarketItem, OpenMarketError>) -> Void) {
        sessionManager.request(method: .patch, path: .item(id: id), data: data) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(MarketItem.self, from: data) else {
                    return completionHandler(.failure(.invalidData))
                }
                completionHandler(.success(decodedData))
            }
        }
    }

    func deleteItem(id: Int, data: DeletingItem, completionHandler: @escaping (Result<MarketItem, OpenMarketError>) -> Void) {
        sessionManager.request(method: .delete, path: .item(id: id), data: data) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(MarketItem.self, from: data) else {
                    return completionHandler(.failure(.invalidData))
                }
                completionHandler(.success(decodedData))
            }
        }
    }
}

//
//  OpenMarketService.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/25.
//

import UIKit

class OpenMarketService {
    private let sessionManager: SessionManagerProtocol

    init(sessionManager: SessionManagerProtocol) {
        self.sessionManager = sessionManager
    }

    func getPage(id: Int, completionHandler: @escaping (Result<Page, OpenMarketError>) -> Void) {
        sessionManager.request(method: .get, path: .page(id: id)) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(Page.self, from: data) else {
                    return completionHandler(.failure(.invalidData))
                }
                completionHandler(.success(decodedData))
            }
        }
    }

    func getItem(id: Int, completionHandler: @escaping (Result<Item, OpenMarketError>) -> Void) {
        sessionManager.request(method: .get, path: .item(id: id)) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(Item.self, from: data) else {
                    return completionHandler(.failure(.invalidData))
                }
                completionHandler(.success(decodedData))
            }
        }
    }

    func postItem(completionHandler: @escaping (Result<Item, OpenMarketError>) -> Void) {
        sessionManager.request(method: .post, path: .item()) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(Item.self, from: data) else {
                    return completionHandler(.failure(.invalidData))
                }
                completionHandler(.success(decodedData))
            }
        }
    }

    func patchItem(id: Int, completionHandler: @escaping (Result<Item, OpenMarketError>) -> Void) {
        sessionManager.request(method: .patch, path: .item(id: id)) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(Item.self, from: data) else {
                    return completionHandler(.failure(.invalidData))
                }
                completionHandler(.success(decodedData))
            }
        }
    }

    func deleteItem(id: Int, completionHandler: @escaping (Result<Item, OpenMarketError>) -> Void) {
        sessionManager.request(method: .delete, path: .item(id: id)) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(Item.self, from: data) else {
                    return completionHandler(.failure(.invalidData))
                }
                completionHandler(.success(decodedData))
            }
        }
    }
}

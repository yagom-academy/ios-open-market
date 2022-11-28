//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by jin on 11/28/22.
//

import Foundation

final class ProductNetworkManager {
    private let networkProvider = NetworkAPIProvider()
    static let shared = ProductNetworkManager()
    private init() {}
    
    func fetchProductList(completion: @escaping (Result<ProductList, Error>) -> Void) {
        networkProvider.fetchProductList(query: [.itemsPerPage: "200"]) { result in
            completion(result)
        }
    }
}

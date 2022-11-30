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
        networkProvider.fetch(url: NetworkAPI.productList(query: [.itemsPerPage: "200"]).urlComponents.url) { result in
            switch result {
            case .success(let data):
                guard let productList: ProductList = JSONDecoder().decode(data: data) else {
                    completion(.failure(NetworkError.decodeFailed))
                    return
                }
                completion(.success(productList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

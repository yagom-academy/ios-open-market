//
//  OpenMarketHealthFetchable.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/16.
//

protocol OpenMarketHealthFetchable: OpenMarketURLSessionProtocol {
    func fetchHealth(completion: @escaping (OpenMarketHealth) -> Void)
}

extension OpenMarketHealthFetchable {
    func fetchHealth(completion: @escaping (OpenMarketHealth) -> Void) {
        let query: String = "healthChecker"
        
        fetchOpenMarketDataTask(query: query) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.bad)
            } else if data != nil {
                completion(.ok)
            }
        }?.resume()
    }
}

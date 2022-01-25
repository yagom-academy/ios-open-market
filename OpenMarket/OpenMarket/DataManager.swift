//
//  DataManager.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/25.
//

import Foundation

struct DataManager {
    func loadData(completionHandler: @escaping (Result<ProductList, NetworkError>) -> Void) {
        let urlSessionProvider = URLSessionProvider()
        
        urlSessionProvider.getData(requestType: .productList(pageNo: 1, items: 20)) { result in
            switch result {
            case .success(let data):
                guard let parsedData: ProductList = self.getParsedData(data: data) else {
                    return
                }
                completionHandler(.success(parsedData))
            case .failure(_):
                return completionHandler(.failure(NetworkError.emptyValue))
            }
        }
    }
    
    private func getParsedData(data: Data) -> ProductList? {
        let decoder = Decoder()
        var parsedData: ProductList? = nil
        
        let result = decoder.parsePageJSON(data: data)
        switch result {
        case .success(let data):
            parsedData = data
        case .failure(let error):
            print(error.localizedDescription)
        }
        return parsedData
    }
}

//
//  DataProvider.swift
//  OpenMarket
//
//  Created by papri, Tiana on 19/05/2022.
//

import Foundation

struct DataProvider {
    func fetchData(index: Int, completionHandler: @escaping ([Product]) -> Void) {
        let itemsPerPage = 20
        let pageNumber = index / itemsPerPage + 1
        
        HTTPManager().loadData(targetURL: .productList(pageNumber: pageNumber, itemsPerPage: itemsPerPage)) { data in
            switch data {
            case .success(let data):
                guard let products = try? JSONDecoder().decode(OpenMarketProductList.self, from: data).products else { return }
                completionHandler(products)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

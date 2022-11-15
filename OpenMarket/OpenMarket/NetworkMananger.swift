//
//  NetworkMananger.swift
//  OpenMarket
//
//  Created by Aaron, Jpush on 2022/11/14.
//

import Foundation

struct NetworkManager {
    let host = "https://openmarket.yagom-academy.kr"
    
    enum requestType {
        case healthChecker
        case searchProductList(Int, Int)
        case searchProductDetail(Int)
    }
    
    private func generateURL(type: requestType) -> URL? {
        switch type {
        case .healthChecker:
            return URL(string: String(format: "%@/healthChecker", host))
        case .searchProductList(let pageNo, let itemsPerPage):
            return URL(string:String(format: "%@/api/products?page_no=%d&items_per_page=%d", host, pageNo, itemsPerPage))
        case .searchProductDetail(let productNumber):
            return URL(string: String(format: "%@/api/products/%d", host, productNumber))
        }
    }

    func fetch(type: requestType, completion: @escaping (completionable) -> Void) {
        guard let url = generateURL(type: type) else {
            return
        }
        
        switch type {
        case .healthChecker:
            getHealthChecker(url) { statusCode in
                completion(statusCode)
            }
        case .searchProductList(let a, let b):
            completion(12)
        case .searchProductDetail(let a):
            print("")
        }
    }
    
    func getHealthChecker(_ url: URL, completion: @escaping (Int) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            let successRange = 200..<300
            
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                return
            }
            
            completion(statusCode)
        }
        
        dataTask.resume()
    }
}

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
    
    func fetch(type: requestType, completion: @escaping (ProductsList) -> Void ) {
        guard let url = generateURL(type: type) else {
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            let successRange = 200..<300
            
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) else {
                return
            }
            
            guard let resultData = data else {
                return
            }
            
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormater)
            guard let result = try? decoder.decode(ProductsList.self, from: resultData) else {
                return
            }
            
            completion(result)
        }
        dataTask.resume()
    }

}

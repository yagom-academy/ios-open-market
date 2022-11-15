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
        case searchProductList(pageNo: Int, itemsPerPage: Int)
        case searchProductDetail(productNumber: Int)
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
        case .searchProductList( _, _):
            getProductsList(url) { productsList in
                completion(productsList)
            }
        case .searchProductDetail( _):
            getProductDetail(url) { product in
                completion(product)
            }
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
    
    func getProductsList(_ url: URL, completion: @escaping (ProductsList) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            let successRange = 200..<300
            
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            guard let result = try? decoder.decode(ProductsList.self, from: data) else {
                return
            }
            
            completion(result)
        }
        
        dataTask.resume()
    }
    
    func getProductDetail(_ url: URL, completion: @escaping (Product) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            let successRange = 200..<300
            
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(formatter)
            print("0")
            
            do {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(formatter)
                print("0")
                let result = try decoder.decode(Product.self, from: data)
                completion(result)
            } catch {
                print(error)
            }
        }
        
        dataTask.resume()
    }
}

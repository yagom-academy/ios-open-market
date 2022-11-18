//
//  NetworkMananger.swift
//  OpenMarket
//
//  Created by Aaron, Jpush on 2022/11/14.
//

import Foundation

struct NetworkManager {
    let successRange = 200..<300
    
    enum requestType {
        case healthChecker
        case searchProductList(pageNo: Int, itemsPerPage: Int)
        case searchProductDetail(productNumber: Int)
    }
    
    private func generateURL(type: requestType) -> URL? {
        let host = "https://openmarket.yagom-academy.kr"
        
        switch type {
        case .healthChecker:
            let url = URL(string: "healthChecker", relativeTo: URL(string: host))
            
            return url?.absoluteURL
        case .searchProductList(let pageNo, let itemsPerPage):
            var components = URLComponents(string: "\(host)/api/products")
            let pageNoParam = URLQueryItem(name: "page_no", value: "\(pageNo)")
            let itemsPerPageParam = URLQueryItem(name: "items_per_page", value: "\(itemsPerPage)")
            components?.queryItems = [pageNoParam, itemsPerPageParam]
            
            return components?.url
        case .searchProductDetail(let productNumber):
            let url = URL(string: "\(productNumber)", relativeTo: URL(string: "\(host)/api/products/"))
            
            return url?.absoluteURL
        }
    }

    func fetch(type: requestType, completion: @escaping (Completionable) -> Void) {
        guard let url = generateURL(type: type) else {
            return
        }
        
        switch type {
        case .healthChecker:
            getHealthChecker(url) { statusCode in
                completion(statusCode)
            }
        case .searchProductList(_, _):
            getProductsList(url) { productsList in
                completion(productsList)
            }
        case .searchProductDetail(_):
            getProductDetail(url) { product in
                completion(product)
            }
        }
    }
    
    private func getHealthChecker(_ url: URL, completion: @escaping (StatusCode) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                return
            }
            
            completion(statusCode)
        }
        
        dataTask.resume()
    }
    
    private func getProductsList(_ url: URL, completion: @escaping (ProductsList) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if isSuccessResponse(response: response, error: error) == false {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let result = try convertJSON(ProductsList.self, from: data)
                completion(result)
            } catch {
                print(error)
            }
        }
        
        dataTask.resume()
    }
    
    private func getProductDetail(_ url: URL, completion: @escaping (Product) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if isSuccessResponse(response: response, error: error) == false {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let result = try convertJSON(Product.self, from: data)
                completion(result)
            } catch {
                print(error)
            }
        }
        
        dataTask.resume()
    }
    
    private func isSuccessResponse(response: URLResponse?, error: Error?) -> Bool {
        guard error == nil,
              let statusCode = (response as? HTTPURLResponse)?.statusCode,
              successRange.contains(statusCode) else {
            return false
        }
        
        return true
    }
    
    private func convertJSON<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable  {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        let result = try decoder.decode(type, from: data)
        return result
    }
}

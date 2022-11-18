//
//  NetworkMananger.swift
//  OpenMarket
//
//  Created by Aaron, Jpush on 2022/11/14.
//

import Foundation

struct NetworkManager {
    let successRange = 200..<300
    typealias StatusCode = Int
    
    enum RequestType {
        case healthChecker
        case searchProductList(pageNo: Int, itemsPerPage: Int)
        case searchProductDetail(productNumber: Int)
    }
    
    private func generateURL(type: RequestType) -> URL? {
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
    
    func getHealthChecker(_ type: RequestType, completion: @escaping (StatusCode) -> Void) {
        guard let url = generateURL(type: type) else {
            return
        }
        
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
    
    func getProductsList(_ type: RequestType, completion: @escaping (ProductsList) -> Void) {
        guard let url = generateURL(type: type) else {
            return
        }
        
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
    
    func getProductDetail(_ type: RequestType, completion: @escaping (Product) -> Void) {
        guard let url = generateURL(type: type) else {
            return
        }
        
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

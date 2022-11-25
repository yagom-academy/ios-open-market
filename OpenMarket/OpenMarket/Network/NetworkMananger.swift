//
//  NetworkMananger.swift
//  OpenMarket
//
//  Created by Aaron, Jpush on 2022/11/14.
//

import Foundation

struct NetworkManager {
    typealias StatusCode = Int
    let successRange = 200..<300
    let cache = {
        let cache = URLCache.shared
//        cache.memoryCapacity = 100000
//        cache.diskCapacity = 0
        return cache
    }()
    
    enum RequestType {
        case healthChecker
        case searchProductList(pageNo: Int, itemsPerPage: Int)
        case searchProductDetail(productNumber: Int)
    }
    
    private func generateURL(type: RequestType) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "openmarket.yagom-academy.kr"
        
        switch type {
        case .healthChecker:
            components.path = "/healthChecker"

            return components.url?.absoluteURL
        case .searchProductList(let pageNo, let itemsPerPage):
            components.path = "/api/products/"
            components.queryItems = [
                URLQueryItem(name: "page_no", value: "\(pageNo)"),
                URLQueryItem(name: "items_per_page", value: "\(itemsPerPage)")
            ]
            
            return components.url?.absoluteURL
        case .searchProductDetail(let productNumber):
            components.path = "/api/products/\(productNumber)"
            
            return components.url?.absoluteURL
        }
    }
    
    func getHealthChecker(completion: @escaping (StatusCode) -> Void) {
        guard let url = generateURL(type: .healthChecker) else {
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
    
    func getProductsList(pageNo: Int, itemsPerPage: Int, completion: @escaping (ProductsList) -> Void) {
        guard let url = generateURL(type: .searchProductList(pageNo: pageNo, itemsPerPage: itemsPerPage)) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        if cache.cachedResponse(for: request) == nil {
            let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
                if isSuccessResponse(response: response, error: error) == false {
                    return
                }
                
                guard let data = data,
                      let response = response else {
                    return
                }
                
                let cacheData = CachedURLResponse(response: response, data: data)
                self.cache.storeCachedResponse(cacheData, for: request)
                
                do {
                    let result = try convertJSON(ProductsList.self, from: data)
                    completion(result)
                } catch {
                    print(error)
                }
            }
            
            dataTask.resume()
        } else {
            guard let data = self.cache.cachedResponse(for: request)?.data else {
                return
            }
            
            do {
                let result = try convertJSON(ProductsList.self, from: data)
                completion(result)
            } catch {
                print(error)
            }
        }
    }
    
    func getProductDetail(productNumber: Int, completion: @escaping (Product) -> Void) {
        guard let url = generateURL(type: .searchProductDetail(productNumber: productNumber)) else {
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

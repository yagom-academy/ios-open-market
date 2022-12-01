//
//  NetworkMananger.swift
//  OpenMarket
//
//  Created by Aaron, Jpush on 2022/11/14.
//

import UIKit

struct NetworkManager {
    typealias StatusCode = Int
    let successRange = 200..<300
    let cache: URLCache = {
        let cache = URLCache.shared
        cache.memoryCapacity = 100000
        cache.diskCapacity = 0
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
    
    func postProductLists(params: Product, images: [UIImage], completion: @escaping () -> Void) {
        /**
         identifier : e475cf3c-6941-11ed-a917-6513cbde46ea
         password : 966j8xcwknjhh7wj
         **/
        guard let url = URL(string: "https://openmarket.yagom-academy.kr/api/products") else {
            return
        }
        let boundary = UUID().uuidString
        print("바운더리 ",boundary)
        let boundaryPrefix = "--\(boundary)\r\n"
        
        var request = URLRequest(url: url)
        // 헤더 작성
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("e475cf3c-6941-11ed-a917-6513cbde46ea", forHTTPHeaderField: "identifier")
        
        var data = Data()
        
        // json형식으로 encode
        let encoder = JSONEncoder()
        
        do {
            let productJSON = try encoder.encode(params)
            let jsonString = String(data: productJSON, encoding: .utf8)
            
            data.append(boundaryPrefix.data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"params\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(String(describing: jsonString))\r\n".data(using: .utf8)!)
            
            data.append(boundaryPrefix.data(using: .utf8)!)
            data.append(("Content-Disposition: form-data; name=\"images\"; filename=\"stone_holy_shit\r\n\r\n".data(using: .utf8)!))
            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            
            
            data.append(images[0].pngData()!)
            print(images[0].pngData()!)
            
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            print(data)
            URLSession.shared.uploadTask(with: request, from: data, completionHandler: { responseData, response, error in
                
                if error == nil {
                    let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                    if let json = jsonData as? [String: Any] {
                        print(json)
                    }
                } else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode
                    print(error!, statusCode!)
                }
            }).resume()
            
        } catch {
            print(error)
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
        
        let request = URLRequest(url: url)
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


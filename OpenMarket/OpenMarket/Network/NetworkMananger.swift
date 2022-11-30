//
//  NetworkMananger.swift
//  OpenMarket
//
//  Created by Aaron, Jpush on 2022/11/14.
//

import UIKit

struct NetworkManager {
    typealias StatusCode = Int
    let jsonParser = JSONParser()
    
    
    let cache: URLCache = {
        let cache = URLCache.shared
        cache.memoryCapacity = 10000000000000
        cache.diskCapacity = 0
        return cache
    }()
    
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
        
        case .patchProduct(let productNumber): fallthrough
        case .searchProductDetail(let productNumber):
            components.path = "/api/products/\(productNumber)"
            
            return components.url?.absoluteURL
        case .searchForDeleteURI(let productNumber):
            components.path = "/api/products/\(productNumber)/archived"
            
            return components.url?.absoluteURL
        case .deleteProduct(path: let path):
            components.path = "\(path)"
            
            return components.url?.absoluteURL
        }
    }
    
    private func isSuccessResponse(response: URLResponse?, error: Error?) -> Bool {
        let successRange = 200..<300
        guard error == nil,
              let statusCode = (response as? HTTPURLResponse)?.statusCode,
              successRange.contains(statusCode) else {
                  return false
              }
        
        return true
    }
}

// MARK: - GET Method
extension NetworkManager {
    func getHealthChecker(completion: @escaping (StatusCode) -> Void) {
        guard let url = generateURL(type: .healthChecker) else {
            return
        }
        
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
                    let result = try jsonParser.decodeJSON(ProductsList.self, from: data)
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
                let result = try jsonParser.decodeJSON(ProductsList.self, from: data)
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
                let result = try jsonParser.decodeJSON(Product.self, from: data)
                completion(result)
            } catch {
                print(error)
            }
        }
        
        dataTask.resume()
    }
}


// MARK: - POST Method
extension NetworkManager {
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
        request.addValue("\(Constant.identifier)", forHTTPHeaderField: "identifier")
        
        var data = Data()
        
        do {
            let productJSON = try jsonParser.encodeJSON(params)
            
            data.append(boundaryPrefix.data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"params\"\r\n\r\n".data(using: .utf8)!)
            data.append(productJSON)
            data.append("\r\n\r\n".data(using: .utf8)!)
            
            data.append(boundaryPrefix.data(using: .utf8)!)
            data.append(("Content-Disposition: form-data; name=\"images\"; filename=\"stone_holy_shit\"\r\n".data(using: .utf8)!))
            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            
            print("===============================================")
            print(String(data: data, encoding: .utf8)!)
            print("===============================================")
            data.append(images[0].pngData()!)
            
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
}

// MARK: - PATCH Method
extension NetworkManager {
    func patchProduct(number: Int, completion: @escaping () -> Void) {
        guard let url = generateURL(type: .patchProduct(number: number)) else {
            return
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Constant.identifier, forHTTPHeaderField: "identifier")
        
        
//            let json = try jsonParser.encodeJSON(product)
//            print(String(data: json, encoding: .utf8)!)
            let product = "{\"name\": \"logo\", \"secret\":\"\(Constant.password)\"}".data(using: .utf8)!
            
            request.httpBody = product
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                print(String(data: data!, encoding: .utf8)!)
                if isSuccessResponse(response: response, error: error) == false {
                    return
                }
                
                completion()
            }
            
            dataTask.resume()
        
    }
}

// MARK: - DELETE MEthod
extension NetworkManager {
    func searchDeleteURI(number: Int, completion: @escaping (Data) -> Void) {
        guard let url = generateURL(type: .searchForDeleteURI(productNumber: number)) else {
            return
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Constant.identifier, forHTTPHeaderField: "identifier")
        request.httpBody = "{\"secret\": \"\(Constant.password)\"}".data(using: .utf8)!
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            print(String(data: data!, encoding: .utf8)!)
            if isSuccessResponse(response: response, error: error) == false {
                return
            }
            
            guard let data = data else {
                return
            }
            completion(data)
        }.resume()
    }
    
    func deleteData(productNumber: Int, completion: @escaping () -> Void) {
        searchDeleteURI(number: productNumber) { data in
            guard let url = generateURL(type: .deleteProduct(path: String(data: data, encoding: .utf8)!)) else {
                return
            }
            var request = URLRequest(url: url)
            
            request.httpMethod = "DELETE"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(Constant.identifier, forHTTPHeaderField: "identifier")

            URLSession.shared.dataTask(with: request) { data, response, error in
                print(String(data: data!, encoding: .utf8)!)
                if isSuccessResponse(response: response, error: error) == false {
                    return
                }
                
                completion()
            }.resume()
        }
    }
}

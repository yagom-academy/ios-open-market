//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 스톤, 로빈 on 2022/11/15.
//

import UIKit

struct NetworkManager {
    let baseURL: String
    var session: URLSessionProtocol
    
    static let identifier = "f5948cd0-6940-11ed-a917-15417865aa81"
    static let secret = "snnq45ezg2tn9amy"
    
    init(urlString: String = "https://openmarket.yagom-academy.kr/",
         session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.baseURL = urlString
        self.session = session
    }
    
    func checkAPIHealth(completion: @escaping (Bool) -> Void) {
        let urlString = "\(baseURL)healthChecker"
        
        guard let url: URL = URL(string: urlString) else { return }
        
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                return completion(false)
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(false)
            }
            
            return completion(httpResponse.statusCode == 200)
        }
        
        dataTask.resume()
    }
    
    func fetchItemList(pageNo: Int, pageCount: Int, completion: @escaping (Result<ItemList, NetworkError>) -> Void) {
        let urlString = "\(baseURL)api/products?page_no=\(pageNo)&items_per_page=\(pageCount)"
        
        guard let url: URL = URL(string: urlString) else { return }
        
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                return completion(.failure(.invalidError))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                return completion(.failure(.responseError))
            }
            
            guard let data = data else { return completion(.failure(.dataError))}
            
            do {
                let itemList: ItemList = try JSONDecoder().decode(ItemList.self, from: data)
                completion(.success(itemList))
            } catch {
                completion(.failure(.parseError))
            }
        }
        
        dataTask.resume()
    }
    
    func fetchItem(productId: Int, completion: @escaping (Result<Item, NetworkError>) -> ()) {
        let urlString = "\(baseURL)api/products/\(productId)"
        
        guard let url: URL = URL(string: urlString) else { return }
        
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                return completion(.failure(.invalidError))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                return completion(.failure(.responseError))
            }
            
            guard let data = data else { return completion(.failure(.dataError))}
            
            do {
                let item: Item = try JSONDecoder().decode(Item.self, from: data)
                completion(.success(item))
            } catch {
                completion(.failure(.parseError))
            }
        }
        
        dataTask.resume()
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage) -> ()) {
        let cachedKey = NSString(string: "\(url)")
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: cachedKey) {
            return completion(cachedImage)
        }
        
        DispatchQueue.global(qos: .utility).async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                ImageCacheManager.shared.setObject(image, forKey: cachedKey)
                completion(image)
            }
        }
    }
}

extension NetworkManager {
    func createRequestBody(params: [String: Data], images: [UIImage], boundary: String) -> Data {
        let newLine = "\r\n"
        let boundaryPrefix = "--\(boundary + newLine)"
        let imgDataKey = "images"
        let mimeType = "image/jpeg"
        
        var body = Data()
        
        for (key, value) in params {
            body.append(boundaryPrefix)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(newLine + newLine)")
            body.append(value)
            body.append(newLine)
        }
        
        for image in images {
            guard let imageData = image.compressTo(expectedSizeInKb: 300) else { return Data() }
            body.append(boundaryPrefix)
            body.append("Content-Disposition: form-data; name=\"\(imgDataKey)\"; filename=\"\(UUID())\"\(newLine)")
            body.append("Content-Type: \(mimeType + newLine + newLine)")
            body.append(imageData)
            body.append(newLine)
        }
        body.append("--".appending(boundary.appending("--")))
        
        return body
    }
    
    func addItem(params: [String: Any], images: [UIImage], completion: @escaping (Result<Item, NetworkError>) -> ()) {
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: URL(string: "\(baseURL)api/products")!)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(NetworkManager.identifier, forHTTPHeaderField: "identifier")
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: params) else { return }
        
        request.httpBody = createRequestBody(params: ["params" : jsonData], images: images, boundary: boundary)
        
        let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                return completion(.failure(.invalidError))
            }
    
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                return completion(.failure(.responseError))
            }
            
            guard let data = data else { return completion(.failure(.dataError)) }
            do {
                let item: Item = try JSONDecoder().decode(Item.self, from: data)
                completion(.success(item))
            } catch {
                completion(.failure(.parseError))
            }
        }
        dataTask.resume()
    }
    
    func deleteURI(productId: Int, password: String,  completion: @escaping (Result<String, NetworkError>) -> ()) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: ["secret": password]) else { return }
        
        var request = URLRequest(url: URL(string: "https://openmarket.yagom-academy.kr/api/products/\(productId)/archived")!)
        request.addValue("\(NetworkManager.identifier)", forHTTPHeaderField: "identifier")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = jsonData
        
        let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                return completion(.failure(.invalidError))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                return completion(.failure(.responseError))
            }
            
            guard let data = data else { return completion(.failure(.dataError)) }
            guard let stringData = String(data: data, encoding: .utf8),
                  let uri = stringData.components(separatedBy: "/").last else { return completion(.failure(.parseError)) }
            
            completion(.success(uri))
        }
        
        dataTask.resume()
    }
    
    func deleteItem(productId: Int, password: String, completion: @escaping (Result<Item, NetworkError>) -> ()) {
        deleteURI(productId: productId, password: password) { result in
            switch result {
            case .success(let deleteURI):
                var request = URLRequest(url: URL(string: "\(baseURL)api/products/\(deleteURI)")!)
                
                request.addValue("\(NetworkManager.identifier)", forHTTPHeaderField: "identifier")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = HTTPMethod.delete.rawValue
                
                let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                    if error != nil {
                        return completion(.failure(.invalidError))
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200..<300).contains(httpResponse.statusCode) else {
                        return completion(.failure(.responseError))
                    }
                    
                    guard let data = data else { return completion(.failure(.dataError)) }
                    
                    do {
                        let item: Item = try JSONDecoder().decode(Item.self, from: data)
                        completion(.success(item))
                    } catch {
                        completion(.failure(.parseError))
                    }
                }
                
                dataTask.resume()
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func editItem(productId: Int, params: [String: Any], completion: @escaping (Result<Item, NetworkError>) -> ()) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: params) else { return }
        
        var request = URLRequest(url: URL(string: "\(baseURL)api/products/\(productId)")!)
        request.addValue("\(NetworkManager.identifier)", forHTTPHeaderField: "identifier")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.patch.rawValue
        request.httpBody = jsonData
        
        let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                return completion(.failure(.invalidError))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                return completion(.failure(.responseError))
            }
            
            guard let data = data else { return completion(.failure(.dataError)) }
            
            do {
                let item: Item = try JSONDecoder().decode(Item.self, from: data)
                completion(.success(item))
            } catch {
                completion(.failure(.parseError))
            }
        }
        
        dataTask.resume()
    }
}


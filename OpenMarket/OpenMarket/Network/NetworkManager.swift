//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 스톤, 로빈 on 2022/11/15.
//

import UIKit
struct ImageFile {
    let filename: String
    let data: Data
    let type: String
}
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
    func addItem(completion: @escaping (String) -> ()) {
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: URL(string: "https://openmarket.yagom-academy.kr/api/products")!)
        
        
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(NetworkManager.identifier, forHTTPHeaderField: "identifier")
        let jsonData = try? JSONSerialization.data(withJSONObject:
                                                    ["name": "호뻥", "description": "간식", "price": 1000, "currency": "KRW", "stock": 1, "secret": "snnq45ezg2tn9amy"])
        request.httpBody = createRequestBody(params: ["params" : jsonData!], boundary: boundary)
        URLSession.shared.dataTask(with: request) { data, rsp, err in
            print("======================================")
            print("=========data==========")
            print(String(data: data!, encoding: .utf8))
            print("=========rsp==========")
            print((rsp as! HTTPURLResponse).statusCode)
            print("=========err==========")
            print(err)
            print("======================================")
        }.resume()
    }
    
    func createRequestBody(params: [String: Data], boundary: String) -> Data {
        let boundaryPrefix = "--\(boundary)\r\n"
        
        var body = Data()
        
        for (key, value) in params {
            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append(value)
            body.append("\r\n".data(using: .utf8)!)
        }
        let imgDataKey = "images"
        let filename = "ghvkdvjscl12.jpeg"
        let mimeType = "image/jpeg"
        guard let imageData = UIImage(named: "ghvjs12")?.jpegData(compressionQuality: 0.5) else { return Data() }
        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(imgDataKey)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        print(String(data: body, encoding: .utf8))
        body.append("--".appending(boundary.appending("--")).data(using: .utf8)!)
        return body
    }

    func deleteURI(completion: @escaping (String) -> ()) {
        let parameters = "{\"secret\": \"\(NetworkManager.secret)\"}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://openmarket.yagom-academy.kr/api/products/384/archived")!)
        request.addValue("\(NetworkManager.identifier)", forHTTPHeaderField: "identifier")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        print(String(data: request.httpBody!, encoding: .utf8)!)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }

            print(String(data: data!, encoding: .utf8)!)
            completion("data")
        }

        task.resume()
    }
}

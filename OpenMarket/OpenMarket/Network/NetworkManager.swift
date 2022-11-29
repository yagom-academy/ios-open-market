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
    // 네트워크 매니저 해야할 일
    
    // 상품 수정, 등록, 삭제 2개
    
    func createBody(params: [String:Any], boundary: String, images: [ImageFile]?) -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in params {
            print("key: \(key), value: \(value)")
            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        if let images = images {
            for image in images {
                body.append(boundaryPrefix.data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(image.filename)\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/\(image.type)\r\n\r\n".data(using: .utf8)!)
                body.append(image.data)
                body.append("\r\n".data(using: .utf8)!)
            }
        }
        
        body.append(boundaryPrefix.data(using: .utf8)!)
        
        return body
    }
    
    func addItem(completion: @escaping (String) -> Void){
        let urlString = "\(baseURL)api/products"
        let boundary = "Boundary-\(UUID().uuidString)"
        
        guard let image = UIImage(named: "Dog")else { return }
        let fileImageData = ImageFile(filename: "Dog", data: image.pngData()!, type: "png")
        
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("c5b13912-43b9-11ed-8b9b-0956155ef06a", forHTTPHeaderField: "identifier")
        request.setValue("multipart/form-data; boundary\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let params: [String:Any] = ["name" : "개껌",
                                   "description" : "간식",
                                    "price" : 1000.0,
                                    "currency" : Currency.krw.rawValue,
                                   "discounted_price" : 100,
                                   "stock" : 100,
                                   "secret" : "snnq45ezg2tn9amy"]
        
        request.httpBody = createBody(params: params, boundary: boundary, images: [fileImageData])
        print("=============================")
        print(request)
        print("=============================")
        URLSession.shared.dataTask(with: request) { data, rsp, err in
            if err != nil {
                return completion("dpfj")
            }
            
            guard let httpResponse = rsp as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                let abc = rsp as? HTTPURLResponse
                return completion("\(abc?.statusCode)스테이터스에러")
            }
            
            guard let data = data else { return completion("데이터에러")}
            
            do {
                //                let item: Item = try JSONDecoder().decode(Item.self, from: data)
                return completion("성공")
            } catch {
                return completion("파싱실패")
                //                completion(.failure(.parseError))
            }
        }.resume()
    }
    
    
    
    func updateItem() {
        
    }
    
    func deleteItem(){
        
    }
}

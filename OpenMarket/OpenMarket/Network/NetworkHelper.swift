//
//  NetworkHelper.swift
//  OpenMarket
//
//  Created by steven on 2021/05/18.
//

import Foundation

struct NetworkHelper {
    
    let session: URLSession
    init (session: URLSession = .shared) {
        self.session = session
    }
    
    func readList(pageNum: Int, completion: @escaping (Result<ProductList, Error>) -> Void) {
        guard let url = URL(string: RequestAddress.readList(page: pageNum).url) else {
            completion(.failure(NetworkError.urlError))
            return
        }
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  (200...399).contains(response.statusCode) else {
                completion(.failure(NetworkError.requestError))
                return
            }
            
            if let data = data,
               let listResponse = try? JSONDecoder().decode(ProductList.self, from: data) {
                completion(.success(listResponse))
                return
            }
        }
        task.resume()
    }
    
    func readItem(itemNum: Int, completion: @escaping (Result<Product, Error>) -> Void ) {
        let request = URLRequest(url: URL(string: RequestAddress.readItem(id: itemNum).url)!)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  (200...399).contains(response.statusCode) else {
                completion(.failure(NetworkError.requestError))
                return
            }
            
            if let data = data,
               let itemResponse = try? JSONDecoder().decode(Product.self, from: data) {
                completion(.success(itemResponse))
                return
            }
            completion(.failure(NetworkError.unknownError))
        }
        task.resume()
    }
    
    func createItem(itemForm: ProductForm ,completion: @escaping (Result<Product, Error>) -> Void) {
        guard let url = URL(string: RequestAddress.createItem.url) else {
            completion(.failure(NetworkError.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        let boundary = "Boundary-\(UUID().uuidString)"
        
        request.httpMethod = HttpMethod.post
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = HttpBodyCreator(boundary: boundary, itemForm: itemForm).make()
        
        session.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  (200...399).contains(response.statusCode) else {
                completion(.failure(NetworkError.requestError))
                return
            }
            if let data = data,
               let responedItem = try? JSONDecoder().decode(Product.self, from: data) {
                completion(.success(responedItem))
                return
            }
            completion(.failure(NetworkError.unknownError))
        }.resume()
    }
    
    func updateItem(itemNum: Int, itemForm: ProductForm, completion: @escaping (Result<Product, Error>) -> Void) {
        guard let url = URL(string: RequestAddress.updateItem(id: itemNum).url) else {
            completion(.failure(NetworkError.urlError))
            return
        }
        var request = URLRequest(url: url)
        let boundary = "Boundary-\(UUID().uuidString)"
        request.httpMethod = HttpMethod.patch
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = HttpBodyCreator(boundary: boundary, itemForm: itemForm).make()
        
        session.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  (200...399).contains(response.statusCode) else {
                completion(.failure(NetworkError.requestError))
                return
            }
            if let data = data,
               let responedItem = try? JSONDecoder().decode(Product.self, from: data){
                completion(.success(responedItem))
                return
            }
            completion(.failure(NetworkError.unknownError))
        }.resume()
    }
    
    func deleteItem(itemNum: Int, password: String, completion: @escaping (Result<Product, Error>) -> Void) {
        guard let url = URL(string: RequestAddress.updateItem(id: itemNum).url) else {
            completion(.failure(NetworkError.urlError))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.delete
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = "{ \"password\": \"\(password)\" }".data(using: .utf8)
        
        session.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  (200...399).contains(response.statusCode) else {
                completion(.failure(NetworkError.requestError))
                return
            }
            if let data = data,
               let responedItem = try? JSONDecoder().decode(Product.self, from: data){
                completion(.success(responedItem))
                return
            }
            completion(.failure(NetworkError.unknownError))
        }.resume()
    }
}

extension Data {
    mutating func appendString(_ string: String) {
        guard let stringData = string.data(using: .utf8) else { return }
        append(stringData)
    }
}

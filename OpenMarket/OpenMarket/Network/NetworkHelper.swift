//
//  NetworkHelper.swift
//  OpenMarket
//
//  Created by steven on 2021/05/18.
//

import Foundation

struct NetworkHelper {
    
    let session: URLSessionProtocol
    init (session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func readList(pageNum: Int, completion: @escaping (Result<ItemsList, Error>) -> Void) {
        guard let url = URL(string: RequestAddress.readList(page: pageNum).url),
              let data = try? String(contentsOf: url).data(using: .utf8),
              let response = try? JSONDecoder().decode(ItemsList.self, from: data)
        else {
            completion(.failure(fatalError()))
            return
        }
        completion(.success(response))        
    }
    
    func readItem(itemNum: Int, completion: @escaping (Result<ItemInfo, Error>) -> Void ) {
//        if let url = URL(string: RequestAddress.readItem(id: itemNum).url),
//              let data = try? String(contentsOf: url).data(using: .utf8),
//              let response = try? JSONDecoder().decode(ItemInfo.self, from: data) {
//            completion(.success(response))
//            return
//        }
//        completion(.failure(fatalError()))
        let request = URLRequest(url: URL(string: RequestAddress.readItem(id: itemNum).url)!)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  (200...399).contains(response.statusCode) else {
                completion(.failure(fatalError()))
                return
            }
            
            if let data = data,
               let itemResponse = try? JSONDecoder().decode(ItemInfo.self, from: data) {
                completion(.success(itemResponse))
                return
            }
            completion(.failure(fatalError()))
        }
        task.resume()
    }
    
    func createItem(itemForm: ItemRegistrationForm ,completion: @escaping (Result<ItemInfo, Error>) -> Void) {
        guard let url = URL(string: RequestAddress.createItem.url) else {
            completion(.failure(fatalError()))
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
                completion(.failure(fatalError()))
                return
            }
            if let data = data,
               let responedItem = try? JSONDecoder().decode(ItemInfo.self, from: data) {
                completion(.success(responedItem))
                return
            }
            completion(.failure(fatalError()))
        }.resume()
    }
    
    func updateItem(itemNum: Int, itemForm: ItemRegistrationForm, completion: @escaping (Result<ItemInfo, Error>) -> Void) {
        guard let url = URL(string: RequestAddress.updateItem(id: itemNum).url) else {
            completion(.failure(fatalError()))
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
                completion(.failure(fatalError()))
                return
            }
            if let data = data,
               let responedItem = try? JSONDecoder().decode(ItemInfo.self, from: data){
                completion(.success(responedItem))
                return
            }
            completion(.failure(fatalError()))
        }.resume()
    }
    
    func deleteItem(itemNum: Int, password: String, completion: @escaping (Result<ItemInfo, Error>) -> Void) {
        guard let url = URL(string: RequestAddress.updateItem(id: itemNum).url) else {
            completion(.failure(fatalError()))
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
                completion(.failure(fatalError()))
                return
            }
            if let data = data,
               let responedItem = try? JSONDecoder().decode(ItemInfo.self, from: data){
                completion(.success(responedItem))
                return
            }
            completion(.failure(fatalError()))
        }.resume()
    }
}

extension Data {
    mutating func appendString(_ string: String) {
        guard let stringData = string.data(using: .utf8) else { return }
        append(stringData)
    }
}

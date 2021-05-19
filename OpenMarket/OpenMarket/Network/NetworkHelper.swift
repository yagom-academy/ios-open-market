//
//  NetworkHelper.swift
//  OpenMarket
//
//  Created by steven on 2021/05/18.
//

import Foundation

enum HttpMethod {
    static let get = "GET"
    static let post = "POST"
    static let patch = "PATCH"
    static let delete = "DELETE"
}

enum RequestAddress {
    static let BaseURL = "https://camp-open-market-2.herokuapp.com/"
    static let items = "items/"
    static let item = "item/"
    
    case readList(page: Int)
    case readItem(id: Int)
    case createItem
    case updateItem(id: Int)
    case deleteItem(id: Int)
    
    var url: String {
        switch self {
        case .readList(let page):
            return RequestAddress.BaseURL + RequestAddress.items + String(page)
        case .readItem(let id):
            return RequestAddress.BaseURL + RequestAddress.item + String(id)
        case .createItem:
            return RequestAddress.BaseURL + RequestAddress.item
        case .updateItem(let id):
            return RequestAddress.BaseURL + RequestAddress.item + String(id)
        case .deleteItem(let id):
            return RequestAddress.BaseURL + RequestAddress.item + String(id)
        }
    }
}

struct NetworkHelper {
    
    let session: URLSession
    init (session: URLSession = .shared) {
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
        if let url = URL(string: RequestAddress.readItem(id: itemNum).url),
              let data = try? String(contentsOf: url).data(using: .utf8),
              let response = try? JSONDecoder().decode(ItemInfo.self, from: data) {
            completion(.success(response))
            return
        }
        completion(.failure(fatalError()))
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
        request.httpBody = HttpBodyCreater(boundary: boundary, itemForm: itemForm).make()
        
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
    
    func updateItem(itemNum: Int, itemForm: ItemRegistrationForm, completion: @escaping (Result<ItemInfo, Error>) -> Void) {
        guard let url = URL(string: RequestAddress.updateItem(id: itemNum).url) else {
            completion(.failure(fatalError()))
            return
        }
        var request = URLRequest(url: url)
        let boundary = "Boundary-\(UUID().uuidString)"
        request.httpMethod = HttpMethod.patch
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = HttpBodyCreater(boundary: boundary, itemForm: itemForm).make()
        
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

struct HttpBodyCreater {
    let boundary: String
    let itemForm: ItemRegistrationForm
    
    func make() -> Data {
        var data = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        // 일반 데이터
        for (key, value) in itemForm.multiFormData {
            data.appendString(boundaryPrefix)
            data.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            data.appendString("\(value)\r\n")
        }
        // 이미지 데이터
        for imageData in itemForm.imagesDatas {
            data.appendString(boundaryPrefix)
            data.appendString("Content-Disposition: form-data; name=\"images[]\"; filename=\"image.png\"\r\n")
            data.appendString("Content-Type: image/png\r\n\r\n")
            data.append(imageData)
            data.appendString("\r\n")
        }
        
        data.appendString("--".appending(boundary.appending("--")))
        
        return data
    }
}

extension Data {
    mutating func appendString(_ string: String) {
        guard let string = string.data(using: .utf8) else { return }
        append(string)
    }
}

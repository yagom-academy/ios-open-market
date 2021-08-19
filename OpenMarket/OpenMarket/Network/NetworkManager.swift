//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/10.
//

import Foundation
typealias Parameters = [String: Any]

enum NetworkError: Error {
    case invalidURL
}

class NetworkManager {
    
    let session: URLSessionProtocol
    let baseUrl = "https://camp-open-market-2.herokuapp.com/"
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func commuteWithAPI(API: Requestable, completion: @escaping(Result<ItemsData, Error>) -> Void) {
        guard let url = try? createURL(url: baseUrl + API.format.path) else {
            print("invalidURL")
            return
        }
        let request = createRequest(url: url, httpMethod: API.format.method, contentType: API.contentType)
        session.dataTask(with: request) { data, response, error in
            if let error = error { return completion(.failure(error)) }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else { return }
            print(response)
            guard let data = data, let items = try? JsonDecoder.decodedJsonFromData(type: ItemsData.self, data: data) else { return }
            print(items)
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }.resume()
        
    }
    
    //    func getItems(page: String, completion: @escaping(Result<ItemsData, Error>) -> Void) {
    //        guard let url = URL(string: ApiFormat.getItems.url + page) else { return }
    //        var request = URLRequest(url: url)
    //        request.httpMethod = ApiFormat.getItems.method
    //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //
    //        session.dataTask(with: request) { data, response, error in
    //            if let error = error { return completion(.failure(error)) }
    //
    //            guard let response = response as? HTTPURLResponse,
    //                  (200...299).contains(response.statusCode) else { return }
    //
    //            guard let data = data, let items = try? JsonDecoder.decodedJsonFromData(type: ItemsData.self, data: data) else { return }
    //            DispatchQueue.main.async {
    //                completion(.success(items))
    //            }
    //        }.resume()
    //    }
    //
    //    func getItem(id: String, completion: @escaping(Result<ItemData, Error>) -> Void) {
    //        guard let url = URL(string: ApiFormat.getItem.url + id) else { return }
    //        var request = URLRequest(url: url)
    //        request.httpMethod = ApiFormat.getItem.method
    //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //
    //        session.dataTask(with: request) { data, response, error in
    //            if let error = error { return completion(.failure(error)) }
    //
    //            guard let response = response as? HTTPURLResponse,
    //                  (200...299).contains(response.statusCode) else { return }
    //
    //            guard let data = data, let item = try? JsonDecoder.decodedJsonFromData(type: ItemData.self, data: data) else { return }
    //            DispatchQueue.main.async {
    //                completion(.success(item))
    //            }
    //        }.resume()
    //    }
    //
    //    func postItem(item: PostItemData, completion: @escaping(Result<Data, Error>) -> Void) {
    //        let parameters = item.parameter()
            guard let mediaImage = Media(withImage: #imageLiteral(resourceName: "1f363"), forKey: "images[]") else { return }
    //        guard let url = URL(string: ApiFormat.post.url) else { return }
    //
    //        let boundary = generateBoundary()
    //
    //        var request = URLRequest(url: url)
    //        request.httpMethod = ApiFormat.post.method
    //        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    //
    //        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
    //        request.httpBody = dataBody
    //
    //        session.dataTask(with: request) { data, response, error in
    //            if let error = error { return completion(.failure(error)) }
    //
    //            guard let response = response as? HTTPURLResponse,
    //                  (200...299).contains(response.statusCode) else { return }
    //
    //            guard let data = data else { return }
    //            completion(.success(data))
    //        }.resume()
    //    }
    //
    //    func patchItem(item: PatchItemData, id: String, completion: @escaping(Result<Data, Error>) -> Void){
    //        let parameters = item.parameter()
    //        guard let mediaImage = Media(withImage: #imageLiteral(resourceName: "test2"), forKey: "images[]") else { return }
    //        guard let url = URL(string: ApiFormat.patch.url + id) else { return }
    //
    //        let boundary = generateBoundary()
    //
    //        var request = URLRequest(url: url)
    //        request.httpMethod = ApiFormat.patch.method
    //        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    //
    //        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
    //        request.httpBody = dataBody
    //
    //        session.dataTask(with: request) { data, response, error in
    //            if let error = error { return completion(.failure(error)) }
    //
    //            guard let response = response as? HTTPURLResponse,
    //                  (200...299).contains(response.statusCode) else { return }
    //
    //            guard let data = data else { return }
    //            completion(.success(data))
    //        }.resume()
    //    }
    //
    //    func deleteItem(id: String, password: String, completion: @escaping(Result<Data, Error>) -> Void) {
    //        guard let url = URL(string: ApiFormat.delete.url + id) else { return }
    //        var request = URLRequest(url: url)
    //        request.httpMethod = ApiFormat.delete.method
    //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //
    //        let deleteItemData = DeleteItemData(password: password)
    //        guard let jsonBody = try? JSONEncoder().encode(deleteItemData) else { return }
    //        request.httpBody = jsonBody
    //
    //        session.dataTask(with: request) { data, response, error in
    //            if let error = error { return completion(.failure(error)) }
    //
    //            guard let response = response as? HTTPURLResponse,
    //                  (200...299).contains(response.statusCode) else { return }
    //
    //            guard let data = data else { return }
    //            completion(.success(data))
    //        }.resume()
    //    }
}
//MARK: URL, URLRequest, RequestDataBody 구성 파트
extension NetworkManager {
    func createURL(url: String) throws -> URL {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        return url
    }
    
    func createRequest(url: URL, httpMethod: String, contentType: ContentType) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue(contentType.description, forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\r\n")
                body.append("Content-Type: \(photo.mimeType)\r\n\r\n")
                body.append(photo.data)
                body.append("\r\n")
            }
        }
        body.append("--\(boundary)--\r\n")
        
        return body
    }
}


extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

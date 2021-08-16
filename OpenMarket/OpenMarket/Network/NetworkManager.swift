//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/10.
//

import Foundation
typealias parameters = [String: Any]

class NetworkManager {
    func getItems(page: String) {
        guard let url = URL(string: ApiFormat.getItems.url + page) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = ApiFormat.getItems.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let response = response else { return }
            print(response)
            
            guard let data = data else { return }
            
            guard let item = try? JsonDecoder.decodedJsonFromData(type: ItemsData.self, data: data) else { return }
            print(item)
        }.resume()
    }
    
    func getItem(id: String) {
        guard let url = URL(string: ApiFormat.getItem.url + id) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = ApiFormat.getItem.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let response = response else { return }
            print(response)
            
            guard let data = data else { return }
            
            guard let item = try? JsonDecoder.decodedJsonFromData(type: ItemData.self, data: data) else { return }
            print(item)
        }.resume()
    }
    
    func postItem(item: PostItemData) {
        let parameters = item.parameter()
        guard let mediaImage = Media(withImage: #imageLiteral(resourceName: "1f363"), forKey: "images[]") else { return }
        guard let url = URL(string: ApiFormat.post.url) else { return }
        
        let boundary = generateBoundary()
        
        var request = URLRequest(url: url)
        request.httpMethod = ApiFormat.post.method
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        print(String(decoding: dataBody, as: UTF8.self))
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response)
            }
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func patchItem(item: PatchItemData, id: String) {
        let parameters = item.parameter()
        guard let mediaImage = Media(withImage: #imageLiteral(resourceName: "test2"), forKey: "images[]") else { return }
        guard let url = URL(string: ApiFormat.patch.url + id) else { return }
        
        let boundary = generateBoundary()
        
        var request = URLRequest(url: url)
        request.httpMethod = ApiFormat.patch.method
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        print(String(decoding: dataBody, as: UTF8.self))
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response)
            }
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func deleteItem(id: String, password: String) {
        guard let url = URL(string: ApiFormat.delete.url + id) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = ApiFormat.delete.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let deleteItemData = DeleteItemData(password: password)
        guard let jsonBody = try? JSONEncoder().encode(deleteItemData) else { return }
        request.httpBody = jsonBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let response = response else { return }
            print(response)
            
            guard let data = data else { return }
            
            guard let item = try? JsonDecoder.decodedJsonFromData(type: ItemData.self, data: data) else { return }
            print(item)
        }.resume()
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    func createDataBody(withParameters params: parameters?, media: [Media]?, boundary: String) -> Data {
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

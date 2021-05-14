//
//  DataManager.swift
//  OpenMarket
//
//  Created by 배은서 on 2021/05/11.
//

import Foundation

struct DataManager {
    
    let session = URLSession.shared

    enum OpenMarketError: Error, LocalizedError {
        case invalidURL
        case decodingFailure
        case encodingFailure
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "잘못된 URL입니다🚨"
            case .decodingFailure:
                return "디코딩 실패🚨"
            case .encodingFailure:
                return "인코딩 실패🚨"
            }
        }
    }
    
    enum HTTPMethod: CustomStringConvertible {
        case get, post, put, patch, delete
        
        var description: String {
            switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .put:
                return "PUT"
            case .patch:
                return "PATCH"
            case .delete:
                return "DELETE"
            }
        }
    }
    
    func dataTaskWithNoBody(_ requestURL: URL, completionHandler: @escaping (Data) -> Void) {
        session.dataTask(with: requestURL) { data, response, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                print("response")
                return
            }
            
            if let mimeType = response.mimeType, mimeType == "application/json",
               let data = data {
                completionHandler(data)
            }
            
        }.resume()
    }
    
    func dataTaskWithBody(_ urlRequest: URLRequest, completionHandler: @escaping (ItemResponse) -> Void) {
        session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            print(response)
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                print("response")
                return
            }
            
            guard let data = data else {
                print("data")
                return
            }
            
            guard let output = try? JSONDecoder().decode(ItemResponse.self, from: data) else {
                print(OpenMarketError.decodingFailure)
                return
            }
            
            completionHandler(output)
        }.resume()
    }
    
    func requestItemList(url: URL?, completionHandler: @escaping (Result<ItemList, OpenMarketError>) -> Void) {
        guard let requestURL = url else { return }
        
        dataTaskWithNoBody(requestURL) { data in
            do {
                let decodedData = try JSONDecoder().decode(ItemList.self, from: data)
                completionHandler(.success(decodedData))
            } catch {
                completionHandler(.failure(.decodingFailure))
            }

        }
    }
    
    func requestItemDetail(url: URL?) {
        guard let requestURL = url else { return }
        
        dataTaskWithNoBody(requestURL) { data in
            do {
                let decodedData = try JSONDecoder().decode(Item.self, from: data)
                print(decodedData)
            } catch {
                print(OpenMarketError.decodingFailure)
            }
        }
    }
    
    func deleteItem(url: URL?, body: ItemForDelete) {
        guard let requestURL = url else { return }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.description
        guard let body = try? JSONEncoder().encode(body) else { return }
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        dataTaskWithBody(request) { data in
            print(data)
        }
    }
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
//    private func createBody(
//        parameters: [String: Any],
//        boundary: String,
//        data: Data,
//        mimeType: String,
//        filename: String
//    ) -> Data {
//        var body = Data()
//        let imgDataKey = "img"
//        let boundaryPrefix = "--\(boundary)\r\n"
//
//        for (key, value) in parameters {
//            body.append(boundaryPrefix.data(using: .utf8)!)
//            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
//            body.append("\(value)\r\n".data(using: .utf8)!)
//        }
//
//        body.append(boundaryPrefix.data(using: .utf8)!)
//        body.append("Content-Disposition: form-data; name=\"\(imgDataKey)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
//        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
//        body.append(data)
//        body.append("\r\n".data(using: .utf8)!)
//        body.append("--".appending(boundary.appending("--")).data(using: .utf8)!)
//        return body
//    }
    
    func createBody(parameters: [String: Any], boundary: String) -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            if let value = value as? [Data] {
                body.append(converFormData(name: key, images: value, boundary: boundary))
            } else {
                body.append(convertFormData(name: key, value: value, boundary: boundary))
            }
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
    
    func convertFormData(name: String, value: Any, boundary: String) -> Data {
        var data = Data()
        
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(value)\r\n".data(using: .utf8)!)
        
        return data
    }
    
    func converFormData(name: String, images: [Data], boundary: String) -> Data {
        var data = Data()
        var imageIndex = 0
        
        for image in images {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"images[]\"; filename=\"aaa.png\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            data.append(image)
            data.append("\r\n".data(using: .utf8)!)
            //data.append("--".appending(boundary.appending("--")).data(using: .utf8)!)
            imageIndex += 1
        }
        
        return data
    }
        
    
    func editItem(url: URL?, body: ItemForEdit) {
        let boundary = generateBoundaryString()
        guard let requestURL = url else { return }
        
        //var resource = Resource(url: requestURL, method: .patch, boundary: boundary)
        
        guard let encoded: Data = try? JSONEncoder().encode(body) else {
            print(OpenMarketError.encodingFailure)
            return
        }
        let body: [String: Any] = try! JSONSerialization.jsonObject(with: encoded, options: []) as! [String : Any]
        print(body)
        let bodyData = createBody(parameters: body, boundary: boundary)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PATCH"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyData
        
        //let bodyDataString = try! JSONSerialization.jsonObject(with: bodyData, options: [])
        
        print(bodyData)
        
        dataTaskWithBody(request) { data in
            //guard let itemResponse = try? JSONDecoder().decode(ItemResponse.self, from: data) else { return }
            print(data)
        }
    }
    
    func registerItem(url: URL?, body: ItemForRegistration) {
        let boundary = generateBoundaryString()
        guard let requestURL = url else { return }
        
        //var resource = Resource(url: requestURL, method: .patch, boundary: boundary)
        
        guard let encoded: Data = try? JSONEncoder().encode(body) else {
            print(OpenMarketError.encodingFailure)
            return
        }
        let body: [String: Any] = try! JSONSerialization.jsonObject(with: encoded, options: []) as! [String : Any]
        print(body)
        let bodyData = createBody(parameters: body, boundary: boundary)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyData
        
        //let bodyDataString = try! JSONSerialization.jsonObject(with: bodyData, options: [])
        
        print(bodyData)
        
        dataTaskWithBody(request) { data in
            //guard let itemResponse = try? JSONDecoder().decode(ItemResponse.self, from: data) else { return }
            print(data)
        }
    }
    
}

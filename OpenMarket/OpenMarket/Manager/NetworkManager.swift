//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by JINHONG AN on 2021/08/13.
//

import Foundation

struct NetworkManager {
    
    func lookUpList(on pageNum: Int, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let methodForm = OpenMarketAPIConstants.listGet
        guard let url = URL(string: methodForm.path + "\(pageNum)") else {
            return completionHandler(.failure(NetworkError.invalidURL))
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = methodForm.method
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let response = response as? HTTPURLResponse,
               OpenMarketAPIConstants.rangeOfSuccessState.contains(response.statusCode),
               let data = data {
                DispatchQueue.main.async {
                    completionHandler(.success(data))
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkError.unknown))
                }
            }
        }.resume()
    }
    
    func generateBoundary() -> String {
        return UUID().uuidString
    }
    
    func createDataBody(with parameters: [String: Any],and medias: [Media]?,separatedInto boundary: String) -> Data {
        let linebreak = OpenMarketAPIConstants.lineBreak
        let doubleHypen = OpenMarketAPIConstants.doubleHypen
        var body = Data()
        
        for (key, value) in parameters {
            body.append("\(doubleHypen + boundary + linebreak)")
            body.append(createContentDisposition(with: key))
            body.append("\(value)\(linebreak)")
        }
        
        if let medias = medias {
            for media in medias {
                body.append("\(doubleHypen + boundary + linebreak)")
                body.append(createContentDisposition(with: media.key, for: media))
                body.append("Content-Type: \(media.contentType)\(linebreak + linebreak)")
                body.append(media.data)
                body.append(linebreak)
            }
        }
        body.append("\(doubleHypen + boundary + doubleHypen + linebreak)")
        return body
    }
    
    func registerProduct(with parameters: [String: Any],and medias: [Media]?, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let methodForm = OpenMarketAPIConstants.post
        let boundary = generateBoundary()
        guard let url = URL(string: methodForm.path) else {
            return completionHandler(.failure(NetworkError.invalidURL))
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = methodForm.method
        urlRequest.setValue("\(MimeType.multipartedFormData); boundary = \(boundary)", forHTTPHeaderField: "Content-Type")
        let dataBody = createDataBody(with: parameters, and: medias, separatedInto: boundary)
        urlRequest.httpBody = dataBody
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let response = response as? HTTPURLResponse,
               OpenMarketAPIConstants.rangeOfSuccessState.contains(response.statusCode),
               let data = data {
                DispatchQueue.main.async {
                    completionHandler(.success(data))
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkError.unknown))
                }
            }
        }.resume()
    }
    
    func createContentDisposition(with key: String, for media: Media? = nil) -> String {
        let lineBreak = OpenMarketAPIConstants.lineBreak
        var basicForm = "Content-Disposition: form-data; name=\"\(key)\""
        if let media = media {
            if let fileName = media.fileName {
                basicForm.append("; filename=\"\(fileName)\"")
            }
            basicForm.append("\(lineBreak)")
        } else {
            basicForm.append("\(lineBreak + lineBreak)")
        }
        return basicForm
    }
        


}

//TODO: 리팩토링할 수 있는 부분은 리팩토링 -> PR 하고 -> 나머지 PATCH 등 구현 -> Mock Test
//건이 네비게이터


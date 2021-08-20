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
    case invalidResult
    case unownedResponse
    case unownedData
}

class NetworkManager {

    let session: URLSessionProtocol
    let baseUrl = "https://camp-open-market-2.herokuapp.com/"
    lazy var boundary = generateBoundary()

    var valuableMethod: [APIMethod] = []
    
    
    init(session: URLSessionProtocol = URLSession.shared, valuableMethod: [APIMethod] = APIMethod.allCases) {
        self.session = session
        self.valuableMethod = valuableMethod
    }

    func commuteWithAPI(API: Requestable, completion: @escaping(Result<Data, Error>) -> Void) {
        guard let request = try? createRequest(url: API.url, API: API) else { return }
        
        guard valuableMethod.contains(API.method) else {
            return completion(.failure(NetworkError.invalidResult))
        }

        session.dataTask(with: request) { data, response, error in
            if let error = error { return completion(.failure(error)) }

            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                return completion(.failure(NetworkError.unownedResponse))
            }
            debugPrint(response)
            
            guard let data = data else {
                return completion(.failure(NetworkError.unownedData))
            }
            debugPrint(String(decoding: data, as: UTF8.self))
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }.resume()
    }
}

//MARK: URL, URLRequest, RequestDataBody 구성 파트
extension NetworkManager {

    private func createRequest(url: String, API: Requestable) throws -> URLRequest {
        guard let url = URL(string: url) else { throw NetworkError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = API.method.method
        
        if API.contentType == ContentType.multipart {
            request.setValue(API.contentType.description + boundary, forHTTPHeaderField: "Content-Type")
        } else {
            request.setValue(API.contentType.description, forHTTPHeaderField: "Content-Type")
        }
        
        if let api = API as? DeleteAPI {
            guard let body = try? JSONEncoder().encode(api.deleteItemData) else { throw NetworkError.invalidResult}
            request.httpBody = body
        } else if let api = API as? RequestableWithBody {
            let body = createDataBody(withParameters: api.parameter, media: api.items)
             request.httpBody = body
               
            debugPrint(String(decoding: body, as: UTF8.self))
        }
        
        
        return request
    }

    private func generateBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }

    private func createDataBody(withParameters params: Parameters?, media: [Media]?) -> Data {
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

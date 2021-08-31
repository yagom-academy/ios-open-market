//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/31.
//

import Foundation

typealias Parameters = [String: Any]

class NetworkManager {
    private let session: URLSession
    lazy var boundary = generateBoundary()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func commuteWithAPI(with API: RequestAPI, completion: @escaping(Result<Data, Error>) -> Void) {
        guard let request = try? createRequest(API: API) else {
            return completion(.failure(NetworkError.invalidRequest))
        }

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return completion(.failure(NetworkError.invalidResponse))
            }
            guard let data = data else {
                return completion(.failure(NetworkError.invalidData))
            }
            debugPrint(String(decoding: data, as: UTF8.self))
            completion(.success(data))
        }.resume()
    }
}

extension NetworkManager {
    private func createURL(from API: RequestAPI) -> URL? {
        let url = URL(string: API.url.description)
        return url
    }
    
    private func createRequest(API: RequestAPI) throws -> URLRequest {
        guard let url = createURL(from: API) else {
            throw NetworkError.invaildURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = API.method.description

        if API.contentType == .multipart {
            request.setValue(API.contentType.description + boundary, forHTTPHeaderField: "Content-Type")
        } else {
            request.setValue(API.contentType.description, forHTTPHeaderField: "Content-Type")
        }

        
        if let api = API as? DeleteItemAPI {
            guard let body = try? JSONEncoder().encode(api.deleteItem) else {
                throw NetworkError.invalidData
            }
            request.httpBody = body
        } else if let api = API as? RequestableWithBody {
            request.httpBody = createRequestBody(API: api)
        }
        return request
    }
    
    private func createRequestBody(API: RequestableWithBody) -> Data {
        var body = Data()
        let lineBreakPoint = "\r\n"

        if let parameters = API.parameters {
            for (key, value) in parameters {
                body.append("--\(boundary)\(lineBreakPoint)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreakPoint + lineBreakPoint)")
                body.append("\(value)\(lineBreakPoint)")
            }
        }
        
        if let medias = API.images {
            for media in medias {
                body.append("--\(boundary)\(lineBreakPoint)")
                body.append("Content-Disposition: form-data; name=\"\(media.fieldName)\"; filename=\"\(media.fileName)\"\(lineBreakPoint)")
                body.append("Content-Type: \(media.mimeType)\(lineBreakPoint + lineBreakPoint)")
                body.append(media.fileData)
                body.append(lineBreakPoint)
            }
        }
        body.append("--\(boundary)--\(lineBreakPoint)")

        return body
    }
    
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8){
            append(data)
        }
    }
}

extension NetworkManager {
    func generateBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}

//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/31.
//

import Foundation

typealias Parameters = [String: Any]

class NetworkManager {
    private let session: URLSessionProtocol
    lazy var boundary = makeBoundary()

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func commuteWithAPI(with api: Requestable, completion: @escaping(Result<Data, Error>) -> Void) {
        guard let request = try? createRequest(api: api) else {
            return completion(.failure(NetworkError.invalidRequest))
        }

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }

            if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) == false {
                debugPrint(response)
                return completion(.failure(NetworkError.invalidResponse))
            }

            guard let data = data else {
                return completion(.failure(NetworkError.invalidData))
            }

            completion(.success(data))
        }.resume()
    }
}

// MARK: Request 생성 메소드
extension NetworkManager {
    private func createRequest(api: Requestable) throws -> URLRequest {
        guard let url = URL(string: api.url.description) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = api.method.description
        switch api.contentType {
        case .multipart:
            request.setValue(api.contentType.description + boundary, forHTTPHeaderField: "Content-Type")
        case .json:
            request.setValue(api.contentType.description, forHTTPHeaderField: "Content-Type")
        }

        guard let api = api as? RequestableWithBody else {
            return request
        }
        guard let body = try? createRequestBody(api: api) else {
            throw NetworkError.invalidRequest
        }
        request.httpBody = body
        return request
    }

    private func createRequestBody(api: RequestableWithBody) throws -> Data {
        if let api = api as? RequestableWithJSONBody, let data = try? createRequestBodyWithJSON(api: api) {
            return data
        } else if let api = api as? RequestableWithMultipartBody {
            return createRequestBodyWithMultipart(api: api)
        }
        throw NetworkError.invalidRequest
    }t 

    private func createRequestBodyWithJSON(api: RequestableWithJSONBody) throws -> Data {
        guard let body = try? JSONEncoder().encode(api.json) else {
            throw NetworkError.invalidData
        }
        return body
    }

    private func createRequestBodyWithMultipart(api: RequestableWithMultipartBody) -> Data {
        var body = Data()
        let lineBreakPoint = "\r\n"

        for (key, value) in api.parameters {
            body.append("--\(boundary)\(lineBreakPoint)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreakPoint + lineBreakPoint)")
            body.append("\(value)\(lineBreakPoint)")
        }
        if let medias = api.images {
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
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension NetworkManager {
    func makeBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}

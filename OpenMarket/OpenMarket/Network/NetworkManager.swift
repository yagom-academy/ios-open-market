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
    private var boundary: String {
        return "Boundary-\(UUID().uuidString)"
    }

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func commuteWithAPI(with api: Requestable, completion: @escaping(Result<Data, Error>) -> Void) {
        guard let request = try? createRequest(api: api) else {
            return completion(.failure(NetworkError.invalidRequest))
        }
        debugPrint(request)

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }

            if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) == false {
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
    private func createURL(from api: Requestable) -> URL? {
        let url = URL(string: api.url.description)
        return url
    }

    private func createRequest(api: Requestable) throws -> URLRequest {
        guard let url = URL(string: api.url.description) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = api.method.description

        if api.contentType == .multipart {
            request.setValue(api.contentType.description + boundary, forHTTPHeaderField: "Content-Type")
        } else {
            request.setValue(api.contentType.description, forHTTPHeaderField: "Content-Type")
        }

        if let api = api as? DeleteItemAPI {
            guard let body = try? JSONEncoder().encode(api.deleteItem) else {
                throw NetworkError.invalidData
            }
            request.httpBody = body
        } else if let api = api as? RequestableWithBody {
            request.httpBody = createRequestBody(api: api)
        }
        return request
    }

    private func createRequestBody(api: RequestableWithBody) -> Data {
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

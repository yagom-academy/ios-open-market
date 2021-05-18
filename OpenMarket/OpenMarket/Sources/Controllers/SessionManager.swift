//
//  SessionManager.swift
//  OpenMarket
//
//  Created by 천수현 on 2021/05/13.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"

    var mimeType: String? {
        switch self {
        case .get:
            return nil
        case .post, .patch:
            return "multipart/form-data; boundary=\(RequestBodyEncoder.boundary)"
        case .delete:
            return "application/json"
        }
    }
}

enum URLPath {
    case page(id: Int?)
    case item(id: Int?)

    func asURL() throws -> URL {
        var urlString: String = "https://camp-open-market-2.herokuapp.com/"

        switch self {
        case .page(let id):
            urlString.append("items/")
            if let id = id {
                urlString.append(id.description)
            }
        case .item(let id):
            urlString.append("item/")
            if let id = id {
                urlString.append(id.description)
            }
        }

        guard let url = URL(string: urlString) else { throw OpenMarketError.invalidURL }

        return url
    }
}

class SessionManager {
    static let shared = SessionManager(requestBodyEncoder: RequestBodyEncoder(), session: URLSession.shared)
    let requestBodyEncoder: RequestBodyEncoderProtocol
    let session: URLSessionProtocol

    private init(requestBodyEncoder: RequestBodyEncoderProtocol, session: URLSessionProtocol) {
        self.requestBodyEncoder = requestBodyEncoder
        self.session = session
    }

    func request<DecodedType: Decodable, RequestingType: RequestData>(method: HTTPMethod,
                                                                      path: URLPath,
                                                                      data: RequestingType? = nil,
                                                                      completionHandler: @escaping (Result<DecodedType, OpenMarketError>) -> Void) {
        guard var request = try? URLRequest(url: path.asURL()) else {
            return completionHandler(.failure(.invalidURL))
        }

        request.httpMethod = method.rawValue
        request.setValue(method.mimeType, forHTTPHeaderField: "Content-Type")

        if let data = data {
            do {
                request.httpBody = try requestBodyEncoder.encode(data)
            } catch let error as OpenMarketError {
                completionHandler(.failure(error))
            } catch {
                completionHandler(.failure(.bodyEncodingError))
            }
        }

        session.dataTask(with: request) { data, response, error in
            if error != nil {
                return completionHandler(.failure(.sessionError))
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completionHandler(.failure(.wrongResponse))
            }

            guard let data = data,
                  let decodedData = try? JSONDecoder().decode(DecodedType.self, from: data) else {
                return completionHandler(.failure(.invalidData))
            }

            completionHandler(.success(decodedData))
        }.resume()
    }
}

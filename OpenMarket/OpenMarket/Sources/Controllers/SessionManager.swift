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
    let session: URLSession

    init(requestBodyEncoder: RequestBodyEncoderProtocol, session: URLSession) {
        self.requestBodyEncoder = requestBodyEncoder
        self.session = session
    }

    func request<DecodedType: Decodable>(method: HTTPMethod,
                                         path: URLPath,
                                         completionHandler: @escaping (Result<DecodedType, OpenMarketError>) -> Void) {
        guard let request = try? configureRequestHeader(method: method, path: path) else {
            return completionHandler(.failure(.invalidURL))
        }

        dataTask(request: request, completionHandler: completionHandler).resume()
    }

    func request<DecodedType: Decodable, RequestingType: RequestData>(method: HTTPMethod,
                                                                      path: URLPath,
                                                                      data: RequestingType,
                                                                      completionHandler: @escaping (Result<DecodedType, OpenMarketError>) -> Void) {
        guard var request = try? configureRequestHeader(method: method, path: path) else {
            return completionHandler(.failure(.invalidURL))
        }

        switch method {
        case .get:
            completionHandler(.failure(.requestGETWithData))
        case .post:
            if data is PostingItem { break }
            completionHandler(.failure(.requestDataTypeNotMatch))
        case .patch:
            if data is PatchingItem { break }
            completionHandler(.failure(.requestDataTypeNotMatch))
        case .delete:
            if data is DeletingItem { break }
            completionHandler(.failure(.requestDataTypeNotMatch))
        }

        do {
            request.httpBody = try requestBodyEncoder.encode(data)
        } catch let error as OpenMarketError {
            completionHandler(.failure(error))
        } catch {
            completionHandler(.failure(.bodyEncodingError))
        }

        dataTask(request: request, completionHandler: completionHandler).resume()
    }

    private func configureRequestHeader(method: HTTPMethod, path: URLPath) throws -> URLRequest {
        var request = try URLRequest(url: path.asURL())

        request.httpMethod = method.rawValue
        request.setValue(method.mimeType, forHTTPHeaderField: "Content-Type")

        return request
    }

    private func dataTask<DecodedType: Decodable>(request: URLRequest,
                                                  completionHandler: @escaping (Result<DecodedType, OpenMarketError>) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: request) { data, response, error in
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
        }
    }
}

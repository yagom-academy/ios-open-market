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
    case page(id: Int? = nil)
    case item(id: Int? = nil)

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

class SessionManager: SessionManagerProtocol {
    static let shared = SessionManager(requestBodyEncoder: RequestBodyEncoder(), session: URLSession.shared)
    private let requestBodyEncoder: RequestBodyEncoderProtocol
    private let session: URLSession

    init(requestBodyEncoder: RequestBodyEncoderProtocol, session: URLSession) {
        self.requestBodyEncoder = requestBodyEncoder
        self.session = session
    }

    func request(method: HTTPMethod,
                 path: URLPath,
                 completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        guard let request = try? configureRequestHeader(method: method, path: path) else {
            return completionHandler(.failure(.invalidURL))
        }

        dataTask(request: request, completionHandler: completionHandler).resume()
    }

    func request<APIModel: RequestData>(method: HTTPMethod,
                                        path: URLPath,
                                        data: APIModel,
                                        completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        guard var request = try? configureRequestHeader(method: method, path: path) else {
            return completionHandler(.failure(.invalidURL))
        }

        switch method {
        case .get:
            return completionHandler(.failure(.requestGETWithData))
        case .post:
            if data is PostingItem { break }
            return completionHandler(.failure(.requestDataTypeNotMatch))
        case .patch:
            if data is PatchingItem { break }
            return completionHandler(.failure(.requestDataTypeNotMatch))
        case .delete:
            if data is DeletingItem { break }
            return completionHandler(.failure(.requestDataTypeNotMatch))
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

    func fetchImageDataTask(urlString: String?, completionHandler: @escaping (Data) -> Void) -> URLSessionDataTask? {
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return nil }

        return dataTask(request: URLRequest(url: url)) { result in
            guard let data = try? result.get() else { return }
            return completionHandler(data)
        }
    }

    private func configureRequestHeader(method: HTTPMethod, path: URLPath) throws -> URLRequest {
        var request = try URLRequest(url: path.asURL())

        request.httpMethod = method.rawValue
        request.setValue(method.mimeType, forHTTPHeaderField: "Content-Type")

        return request
    }

    private func dataTask(request: URLRequest,
                          completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: request) { data, response, error in
            if error != nil {
                return completionHandler(.failure(.sessionError))
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                return completionHandler(.failure(.didNotReceivedResponse))
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                return completionHandler(.failure(.wrongResponse(httpResponse.statusCode)))
            }

            guard let data = data else {
                return completionHandler(.failure(.didNotReceivedData))
            }

            completionHandler(.success(data))
        }
    }
}

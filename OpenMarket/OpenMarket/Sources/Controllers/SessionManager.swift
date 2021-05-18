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
}

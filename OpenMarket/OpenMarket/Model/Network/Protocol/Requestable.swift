//
//  Requestable.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/05/17.
//

import Foundation

protocol Requestable: MultipartConvertible {
    func setMultipartRequest<Body: Encodable>(_ url: URL, _ body: Body, httpMethod: HTTPMethod) -> URLRequest?
    func makeRequest<Body: Encodable>(url: URL?, httpMethod: HTTPMethod, _ body: Body) -> URLRequest?
}

extension Requestable {
    func setMultipartRequest<Body: Encodable>(_ url: URL, _ body: Body, httpMethod: HTTPMethod) -> URLRequest? {
        let boundary = generateBoundaryString()
        guard let body: [String: Any] = body.asDictionary() else { return nil }
        let bodyData = createBody(parameters: body, boundary: boundary)
        
        var request = URLRequest.set(url: url, httpMethod: httpMethod)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyData
        
        return request
    }
    
    func makeRequest<Body: Encodable>(url: URL?, httpMethod: HTTPMethod, _ body: Body) -> URLRequest? {
        guard let requestURL = url else { return nil }
        
        switch httpMethod {
        case .delete:
            var request = URLRequest.set(url: requestURL, httpMethod: .delete)
            guard let body = try? JSONEncoder().encode(body) else { return nil }
            request.httpBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
        case .post:
            return setMultipartRequest(requestURL, body, httpMethod: .post)
        case .patch:
            return setMultipartRequest(requestURL, body, httpMethod: .patch)
        default:
            print("존재하지 않는 요청입니다.")
            return nil
        }
    }
}

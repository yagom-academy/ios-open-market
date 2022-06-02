//
//  APIable.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/06/02.
//

import Foundation

protocol APIable {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParameters: [String: String]? { get }
    var bodyParameters: Encodable? { get }
    var headers: [String: String] { get }
}

extension APIable {
    private func makeURL() -> URL? {
        var urlComponents = URLComponents(string: baseURL + path)
        
        if let queryParameters = queryParameters {
            urlComponents?.queryItems = queryParameters.map { key, value in
                return URLQueryItem(name: key, value: value)
            }
        }
        return urlComponents?.url
    }
    func makeURLRequest() -> URLRequest? {
        guard let url = makeURL() else { return nil }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.rawValue
        headers.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        if let bodyParameters = bodyParameters {
            guard let body = try? bodyParameters.toDictionary() else { return nil }
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        return urlRequest
    }
    
    func makeMutiPartFormDataURLRequest() -> URLRequest? {
        guard let url = makeURL() else { return nil }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.rawValue
        headers.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        urlRequest.httpBody = makeMutiPartFormData()
        
        return urlRequest
    }
    
    private func makeMutiPartFormData() -> Data? {
        guard let uploadProduct = bodyParameters as? UploadProduct else { return nil }
        guard let productJsonData = try? JSONEncoder().encode(uploadProduct) else { return nil }
        guard let imageDatas = uploadProduct.images else { return nil }
        
        var data = Data()
        let boundary = UserInformation.boundary
        
        let newLine = "\r\n"
        let boundaryPrefix = "--\(boundary)\r\n"
        let boundarySuffix = "\r\n--\(boundary)--\r\n"
        
        data.appendString(boundaryPrefix)
        data.appendString("Content-Disposition: form-data; name=\"params\"\r\n")
        data.appendString("Content-Type: application/json\r\n")
        data.appendString("\r\n")
        data.append(productJsonData)
        data.appendString(newLine)
        
        imageDatas.forEach { imageData in
            data.appendString(boundaryPrefix)
            data.appendString("Content-Disposition: form-data; name=\"images\"; filename=\"\(imageData.fileName).jpg\"\r\n")
            data.appendString("Content-Type: image/jpg\r\n\r\n")
            data.append(imageData.data)
            data.appendString(newLine)
        }
        data.appendString(boundarySuffix)
        
        return data
    }
}

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        
        return jsonData as? [String: Any]
    }
}

private extension Data {
    mutating func appendString(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        append(data)
    }
}

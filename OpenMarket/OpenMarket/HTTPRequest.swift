//
//  HTTPRequest.swift
//  OpenMarket
//
//  Created by Zero DotOne on 2021/01/27.
//

import Foundation

struct HTTPRequest {
    private let urlString = "https://camp-open-market.herokuapp.com"
    
    func CreateURLRequest(requestAPI: RequestAPI) -> URLRequest? {
        switch requestAPI {
        case .lookupList:
            return lookupList()
        default:
            return nil
        }
    }
    
    func CreateItemRegistrationURLRequest(requestAPI: RequestAPI, bodyData: ItemRegistrationRequest) -> URLRequest? {
        switch requestAPI {
        case .itemRegistration:
            return itemRegistration(bodyData: bodyData)
        default:
            return nil
        }
    }
    
    private func lookupList() -> URLRequest? {
        guard var url = URL(string: urlString) else {
            return nil
        }
        let path = "/items/1"
        url.appendPathComponent(path)
        
        let urlRequest = URLRequest(url: url)
        
        return urlRequest
    }
    
    private func itemRegistration(bodyData: ItemRegistrationRequest) -> URLRequest? {
        guard var url = URL(string: urlString) else {
            return nil
        }
        let path = "/item"
        url.appendPathComponent(path)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        let boundary = UUID().uuidString
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = addMultipartFormDataToBody(paramters: bodyData, boundary: boundary)
        
        return urlRequest
    }
    
    private func addMultipartFormDataToBody(paramters: ItemRegistrationRequest, boundary: String) -> Data? {
        var body = Data()
        guard let title = makeMultipartFormParameter(parameter: "title", value: paramters.title, boundary: boundary) else {
            return nil
        }
        guard let descriptions = makeMultipartFormParameter(parameter: "descriptions", value: paramters.descriptions, boundary: boundary) else {
            return nil
        }
        guard let price = makeMultipartFormParameter(parameter: "price", value: String(paramters.price), boundary: boundary) else {
            return nil
        }
        guard let currency = makeMultipartFormParameter(parameter: "currency", value: paramters.currency, boundary: boundary) else {
            return nil
        }
        guard let stock = makeMultipartFormParameter(parameter: "stock", value: String(paramters.stock), boundary: boundary) else {
            return nil
        }
        guard let password = makeMultipartFormParameter(parameter: "password", value: paramters.password, boundary: boundary) else {
            return nil
        }
        guard let lastBoundaryLine = "--\(boundary)--\r\n".data(using: .utf8) else {
            return nil
        }
        
        body.append(title)
        body.append(descriptions)
        body.append(price)
        body.append(currency)
        body.append(stock)
        body.append(password)
        body.append(lastBoundaryLine)
        
        return body
    }
    
    private func makeMultipartFormParameter(parameter: String, value: String, boundary: String) -> Data? {
        var body = Data()
        
        guard let boundaryLine = "--\(boundary)\r\n".data(using: .utf8) else {
            return nil
        }
        guard let contentDispositionLine = "Content-Disposition: form-data; name=\"\(parameter)\"\r\n\r\n".data(using: .utf8) else {
            return nil
        }
        guard let data = value.data(using: .utf8) else {
            return nil
        }
        guard let lineBreak = "\r\n".data(using: .utf8) else {
            return nil
        }
        
        body.append(boundaryLine)
        body.append(contentDispositionLine)
        body.append(data)
        body.append(lineBreak)
        
        return body
    }
}

enum RequestAPI {
    case lookupList
    case itemRegistration
    case itemSpecification
    case itemModification
    case itemDeletion
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

//
//  HTTPRequest.swift
//  OpenMarket
//
//  Created by Zero DotOne on 2021/01/27.
//

import Foundation

struct OpenMarketHTTPRequest {
    private enum URLAddress {
        case searchItemList(Int)
        case registerItem
        case searchItem(Int)
        case modifyItem(Int)
        case deleteItem(Int)
        
        var url: String {
            "https://camp-open-market.herokuapp.com"
        }
        
        var path: String {
            switch self {
            case .searchItemList(let page):
                return "/items/\(page)"
            case .registerItem:
                return "/item"
            case .searchItem(let id), .modifyItem(let id), .deleteItem(let id):
                return "/item/\(id)"
            }
        }
        
        var fullURL: URL? {
            URL(string: url)?.appendingPathComponent(path)
        }
    }
    
    func itemList(_ page: Int) -> URLRequest? {
        guard let url = URLAddress.searchItemList(page).fullURL else {
            return nil
        }
        let urlRequest = URLRequest(url: url)
        
        return urlRequest
    }
    
    func itemRegistration(_ bodyData: ItemRegistrationRequest) -> URLRequest? {
        guard let url = URLAddress.registerItem.fullURL else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        let boundary = UUID().uuidString
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = addMultipartFormDataToBody(paramters: bodyData, boundary: boundary)
        
        return urlRequest
    }
    
    func itemSpecification(_ id: Int) -> URLRequest? {
        guard let url = URLAddress.searchItem(id).fullURL else {
            return nil
        }
        
        let urlRequest = URLRequest(url: url)
        
        return urlRequest
    }
    
    func itemModification(_ id: Int, _ bodyData: ItemModificationRequest) -> URLRequest? {
        guard let url = URLAddress.modifyItem(id).fullURL else {
            return nil   
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.patch.rawValue
        let boundary = UUID().uuidString
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = addMultipartFormDataToBody(paramters: bodyData, boundary: boundary)
        
        return urlRequest
    }
    
    func itemDeletion(_ id: Int, _ bodyData: ItemDeletionRequest) -> URLRequest? {
        guard let url = URLAddress.deleteItem(id).fullURL else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.delete.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let body = try? JSONEncoder().encode(bodyData) {
            urlRequest.httpBody = body
        }
        
        return urlRequest
    }
    
    private func addMultipartFormDataToBody(paramters: ItemModificationRequest, boundary: String) -> Data {
        var body = Data()
        
        for (parameter, value) in paramters.description {
            if let data = value as? [Data] {
                body.append(makeMultipartFormDataParameter(parameter: parameter, value: data, boundary: boundary))
            } else {
                body.append(makeMultipartFormParameter(parameter: parameter, value: value, boundary: boundary))
            }
        }
        
        let lastBoundaryLine = "--\(boundary)--\r\n"
        body.append(lastBoundaryLine)
        
        return body
    }
    
    private func addMultipartFormDataToBody(paramters: ItemRegistrationRequest, boundary: String) -> Data {
        var body = Data()
        
        for (parameter, value) in paramters.description {
            if let data = value as? [Data] {
                body.append(makeMultipartFormDataParameter(parameter: parameter, value: data, boundary: boundary))
            } else {
                body.append(makeMultipartFormParameter(parameter: parameter, value: value, boundary: boundary))
            }
        }
        
        let lastBoundaryLine = "--\(boundary)--\r\n"
        body.append(lastBoundaryLine)
        
        return body
    }
    
    private func makeMultipartFormParameter(parameter: String, value: Any, boundary: String) -> Data {
        var body = Data()
        
        let boundaryLine = "--\(boundary)\r\n"
        let contentDispositionLine = "Content-Disposition: form-data; name=\"\(parameter)\"\r\n\r\n"
        if let data = value as? String {
            body.append(data)
        } else if let data = value as? Int {
            body.append(String(data))
        }
        let lineBreak = "\r\n"
        
        body.append(boundaryLine)
        body.append(contentDispositionLine)
        body.append(lineBreak)
        
        return body
    }
    
    private func makeMultipartFormDataParameter(parameter: String, value: [Data], boundary: String) -> Data {
        var body = Data()
        
        for image in value {
            let boundaryLine = "--\(boundary)\r\n"
            let contentDispositionLine = "Content-Disposition: form-data; name=\"\(parameter)[]\"; filename=\"image1.png\"\r\n"
            let contentType = "Content-Type: image/png\r\n\r\n"
            let lineBreak = "\r\n"
            
            body.append(boundaryLine)
            body.append(contentDispositionLine)
            body.append(contentType)
            body.append(image)
            body.append(lineBreak)
        }
        
        return body
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) { append(data) }
    }
}

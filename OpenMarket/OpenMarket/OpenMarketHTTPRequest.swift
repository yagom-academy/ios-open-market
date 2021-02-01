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
    
    private func addMultipartFormDataToBody(paramters: ItemModificationRequest, boundary: String) -> Data? {
        var body = Data()
        if let title = paramters.title {
            let titleData = makeMultipartFormParameter(parameter: "title", value: title, boundary: boundary)
                body.append(titleData)
        }
        if let descriptions = paramters.descriptions {
            let descriptionsData = makeMultipartFormParameter(parameter: "descriptions", value: descriptions, boundary: boundary)
                body.append(descriptionsData)
        }
        if let price = paramters.price {
            let priceData = makeMultipartFormParameter(parameter: "price", value: String(price), boundary: boundary)
                body.append(priceData)
        }
        if let currency = paramters.currency {
            let currencyData = makeMultipartFormParameter(parameter: "currency", value: currency, boundary: boundary)
                body.append(currencyData)
        }
        if let stock = paramters.stock {
            let stockData = makeMultipartFormParameter(parameter: "stock", value: String(stock), boundary: boundary)
                body.append(stockData)
        }
        if let images = paramters.images {
            let imagesData = makeMultipartFormDataParameter(parameter: "images", value: images, boundary: boundary)
                body.append(imagesData)
        }
        let password = makeMultipartFormParameter(parameter: "password", value: paramters.password, boundary: boundary)
        body.append(password)
        let lastBoundaryLine = "--\(boundary)--\r\n"
        body.append(lastBoundaryLine)
        
        return body
    }
    
    private func addMultipartFormDataToBody(paramters: ItemRegistrationRequest, boundary: String) -> Data {
        var body = Data()
        let title = makeMultipartFormParameter(parameter: "title", value: paramters.title, boundary: boundary)
        let descriptions = makeMultipartFormParameter(parameter: "descriptions", value: paramters.descriptions, boundary: boundary)
        let price = makeMultipartFormParameter(parameter: "price", value: String(paramters.price), boundary: boundary)
        let currency = makeMultipartFormParameter(parameter: "currency", value: paramters.currency, boundary: boundary)
        let stock = makeMultipartFormParameter(parameter: "stock", value: String(paramters.stock), boundary: boundary)
        let images = makeMultipartFormDataParameter(parameter: "images", value: paramters.images, boundary: boundary)
        let password = makeMultipartFormParameter(parameter: "password", value: paramters.password, boundary: boundary)
        let lastBoundaryLine = "--\(boundary)--\r\n"
        
        body.append(title)
        body.append(descriptions)
        body.append(price)
        body.append(currency)
        body.append(stock)
        body.append(images)
        body.append(password)
        body.append(lastBoundaryLine)
        
        return body
    }
    
    private func makeMultipartFormParameter(parameter: String, value: String, boundary: String) -> Data {
        var body = Data()
        
        guard let boundaryLine = "--\(boundary)\r\n".data(using: .utf8) else {
            return body
        }
        guard let contentDispositionLine = "Content-Disposition: form-data; name=\"\(parameter)\"\r\n\r\n".data(using: .utf8) else {
            return body
        }
        guard let data = value.data(using: .utf8) else {
            return body
        }
        guard let lineBreak = "\r\n".data(using: .utf8) else {
            return body
        }
        
        body.append(boundaryLine)
        body.append(contentDispositionLine)
        body.append(data)
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

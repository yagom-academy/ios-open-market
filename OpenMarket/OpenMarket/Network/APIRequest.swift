//
//  APIRequest.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/12.
//

import Foundation
import UIKit.UIImage

enum HTTPMethod {
    case get
    case post
    case delete
    case patch
    
    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .patch:
            return "PATCH"
        }
    }
}

enum HTTPBody {
    case multiPartForm(_ form: MultiPartForm)
    case json(_ json: Data)
}

protocol APIRequest {
    var baseURL: String { get }
    
    var path: String? { get }
    
    var method: HTTPMethod { get }
    
    var headers: [String: String]? { get }
    
    var query: [String: String]? { get }
    
    var body: HTTPBody? { get }
}

extension APIRequest {
    var url: URL? {
        var component = URLComponents(string: self.baseURL + (self.path ?? ""))
        component?.queryItems = query?.reduce([URLQueryItem]())
        {
            $0 + [URLQueryItem(name: $1.key,
                               value: $1.value)]
        }
        
        return component?.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.name
        request.httpBody = createHTTPBody()
        
        self.headers?.forEach
        {
            request.addValue($0.value,
                           forHTTPHeaderField: $0.key)
            
        }
        
        return request
    }
}

//MARK: - MultiPartForm Type

struct MultiPartForm {
    let jsonParameterName: String
    let imageParameterName: String
    let boundary: String
    let jsonData: Data
    let images: [Image]
}

//MARK: - MultiPartForm_Image Type

struct Image {
    let name: String
    let data: Data
    let type: String
}

//MARK: - MultiPartForm method

extension APIRequest {
    private func createHTTPBody() -> Data {
        guard let body = self.body else { return Data() }
        
        switch body {
        case .json(let json):
            return json
        case .multiPartForm(let form):
            return createMultiPartFormBody(form: form)
        }
    }
    
    private func createMultiPartFormBody(form: MultiPartForm) -> Data {
        let lineBreak = "\r\n"
        var requestBody = Data()
        
        requestBody.append(createMultipartFormJsonData(parameterName: form.jsonParameterName,
                                                       boundary: form.boundary,
                                                       json: form.jsonData))
        
        form.images.forEach
        {
            requestBody.append(createMultipartFormImageData(parameterName: form.imageParameterName,
                                                            boundary: form.boundary,
                                                            image: $0))
        }
        
        requestBody.append("\(lineBreak)--\(form.boundary)--\(lineBreak)")
        
        return requestBody
    }
    
    private func createMultipartFormJsonData(parameterName: String, boundary: String, json: Data) -> Data {
        let lineBreak = "\r\n"
        var paramsBody = Data()
        
        paramsBody.append("\(lineBreak)--\(boundary + lineBreak)")
        paramsBody.append("Content-Disposition: form-data; name=\"\(parameterName)\"\(lineBreak)")
        paramsBody.append("Content-Type: application/json \(lineBreak + lineBreak)")
        paramsBody.append(json)
        
        return paramsBody
    }
    
    private func createMultipartFormImageData(parameterName: String, boundary: String, image: Image) -> Data {
        let lineBreak = "\r\n"
        let fileName = image.name + "." + image.type
        let fileType = "image/\(image.type)"
        var imageBody = Data()
        
        imageBody.append("\(lineBreak)--\(boundary + lineBreak)")
        imageBody.append("Content-Disposition: form-data; name=\"\(parameterName)\"; filename=\"\(fileName)\"\(lineBreak)")
        imageBody.append("Content-Type: \(fileType) \(lineBreak + lineBreak)")
        imageBody.append(image.data)
        
        return imageBody
    }
}

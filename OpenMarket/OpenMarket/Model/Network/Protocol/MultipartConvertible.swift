//
//  MultipartConvertible.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/05/17.
//

import Foundation

protocol MultipartConvertible {
    func generateBoundaryString() -> String
    func createBody(parameters: [String: Any], boundary: String) -> Data
    func convertFormData(name: String, value: Any, boundary: String) -> Data
    func convertFormData(name: String, images: [Data], boundary: String) -> Data
}

extension MultipartConvertible {
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    func createBody(parameters: [String: Any], boundary: String) -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            if let value = value as? [Data] {
                body.append(convertFormData(name: key, images: value, boundary: boundary))
            } else {
                body.append(convertFormData(name: key, value: value, boundary: boundary))
            }
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
    
    func convertFormData(name: String, value: Any, boundary: String) -> Data {
        var data = Data()
        
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(value)\r\n".data(using: .utf8)!)
        
        return data
    }
    
    func convertFormData(name: String, images: [Data], boundary: String) -> Data {
        var data = Data()
        var imageIndex = 0
        
        for image in images {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"images[]\"; filename=\"aaa.png\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            data.append(image)
            data.append("\r\n".data(using: .utf8)!)
//            data.append("--".appending(boundary.appending("--")).data(using: .utf8)!)
            imageIndex += 1
        }
        
        return data
    }
}

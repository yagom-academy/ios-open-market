//
//  MultipartConvertible.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/05/17.
//

import Foundation

protocol MultipartConvertible {
    func generateBoundaryString() -> String
    func createBody(parameters: [String: Any?], boundary: String) -> Data
    func convertFormData(name: String, value: Any, boundary: String) -> Data
    func convertFormData(name: String, images: [Data], boundary: String) -> Data
}

extension MultipartConvertible {
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    func createBody(parameters: [String: Any?], boundary: String) -> Data {
        var body = Data()
        print(parameters)
        
        for (key, value) in parameters {
            if value == nil {
                continue
            } else if let value = value as? [Data] {
                body.append(convertFormData(name: key, images: value, boundary: boundary))
            } else if let value = value {
                body.append(convertFormData(name: key, value: value, boundary: boundary))
            }
        }
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    func convertFormData(name: String, value: Any, boundary: String) -> Data {
        var data = Data()
        
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
        data.appendString("\(value)\r\n")
        
        return data
    }
    
    func convertFormData(name: String, images: [Data], boundary: String) -> Data {
        var data = Data()
        var imageIndex = 0
        
        for image in images {
            data.appendString("--\(boundary)\r\n")
            data.appendString("Content-Disposition: form-data; name=\"images[]\"; filename=\"image\(imageIndex).png\"\r\n")
            data.appendString("Content-Type: image/png\r\n\r\n")
            data.append(image)
            data.appendString("\r\n")
            imageIndex += 1
        }
        
        return data
    }
}

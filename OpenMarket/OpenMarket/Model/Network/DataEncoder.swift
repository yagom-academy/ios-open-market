//
//  DataEncoder.swift
//  OpenMarket
//
//  Created by 우롱차 on 2022/06/08.
//

import UIKit

struct DataEncoder {

    private let imageEncoder: ImageEncoder
    private let jsonEncoder: JSONEncoder
    private var boundary: String
    private var boundaryPrefix: String {
            return "\r\n--\(boundary)\r\n"
    }
    
    init(boundary: String, imageEncoder: ImageEncoder = ImageEncoder(), jsonEncoder: JSONEncoder = JSONEncoder()) {
        self.boundary = boundary
        self.imageEncoder = imageEncoder
        self.jsonEncoder = jsonEncoder
    }
    
    func encodeFormData<T: Encodable>(parameter: T) throws -> Data {
        
        var data = Data()
        
        data.appendString(boundaryPrefix)
        data.appendString("Content-Disposition: form-data; name=\"params\"\r\n\r\n")
        
        guard let params = try? jsonEncoder.encode(parameter) else {
            throw(UseCaseError.encodingError)
        }
        
        guard let paramsData = String(data: params, encoding: .utf8) else {
            throw(UseCaseError.encodingError)
        }
        
        data.appendString(paramsData)
        
        return data
    }
    
    func encodeImages(images: [UIImage]) throws -> Data {
        
        var data = Data()
        
        for image in images {
            data.appendString(boundaryPrefix)
            data.appendString("Content-Disposition: form-data; name=\"images\"; filename=\"sampleImage.jpeg\"\r\n")
            data.appendString("Content-Type: image/jpeg\r\n\r\n")
            let imageData = try imageEncoder.encodeImage(image: image)
            
            data.append(imageData)
        }
        data.appendString("\r\n--\(boundary)--\r\n")
        return data
    }
}

//
//  HTTPBody.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.
        
import Foundation

enum ContentType: String {
    case json = "application/json"
    case image = "image/png"
}

struct HttpBody {
    var key: String {
        switch contentType {
        case .json:
            return "params"
        case .image:
            return "images"
        }
    }
    var contentType: ContentType
    var data: Data
    
    func createBody(boundary: String) -> Data {
        let boundary = "\(boundary)\r\n"
        let nextLine = "\r\n"
        let data = NSMutableData()
        
        data.appendString(boundary)
        data.appendString("Content-Disposition: form-data; name=\"\(key)\"")
        
        if contentType == .json {
            data.appendString("\(nextLine)\(nextLine)")
        } else {
            data.appendString("; filename=\"minii\"\(nextLine)")
            data.appendString("Content-Type: \(contentType.rawValue)\(nextLine)\(nextLine)")
        }
        
        data.append(self.data)
        data.appendString(nextLine + nextLine)
        return data as Data
    }
}


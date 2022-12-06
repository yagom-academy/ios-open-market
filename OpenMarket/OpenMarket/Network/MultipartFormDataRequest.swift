//
//  MultipartFormDataRequest.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/12/05.
//

import Foundation
import UIKit

final class MultipartFormDataRequest {
    static let shared = MultipartFormDataRequest()
    
    let boundary: String = UUID().uuidString
    var httpBody = NSMutableData()
    
    func addTextField(value: String) {
        httpBody.append(textFormField(value: value))
    }
    
    private func textFormField(value: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"params\"\r\n"
        fieldString += "Content-Type: application/json\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        
        return fieldString
    }
    
    func addDataField(images: [UIImage]) {
        httpBody.append(dataFormField(images: images))
    }
    
    private func dataFormField(images: [UIImage]) -> Data {
        let fieldData = NSMutableData()
        
        for image in images {
            fieldData.append("--\(boundary)\r\n")
            fieldData.append("Content-Disposition: form-data; name=\"images\"; filename=\"som1\"\r\n")
            fieldData.append("Content-Type: image/png\r\n")
            fieldData.append("\r\n")
            fieldData.append(image.pngData()!)
            fieldData.append("\r\n")
        }
        
        fieldData.append("--\(boundary)--\r\n")
        
        return fieldData as Data
    }
}

extension NSMutableData {
    func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

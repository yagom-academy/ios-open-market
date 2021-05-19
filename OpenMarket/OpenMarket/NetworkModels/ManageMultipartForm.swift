//
//  ManageMultipartForm.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/17.
//

import Foundation
import UIKit

class ManageMultipartForm {
    
    func convertFormField(name: String, value: String, boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"

        return fieldString
    }
    
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, boundary: String) -> Data {
        var data = Data()
         
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
         
        return data
    }
    
}

extension Data {
    
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
          self.append(data)
        }
    }
    
}

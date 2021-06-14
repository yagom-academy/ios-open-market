//
//  MultipartFormManager.swift
//  OpenMarket
//
//  Created by 김민성 on 2021/06/08.
//

import Foundation

class ManageMultipartForm: MultipartFormManagable {
    
    func convertFormField(name: String, value: String, boundary: String) -> Data {
        let headerString = ["--\(boundary)",
                            "Content-Disposition: form-data; name=\"\(name)\"\r\n",
                            "\(value)",
                            "\r\n"]
        
        return headerString.joined(separator: "\r\n").data(using: .utf8)!
    }
    
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, boundary: String) -> Data {
        let headerString = ["--\(boundary)",
                            "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"",
                            "Content-Type: \(mimeType)",
                            "\r\n\r\n"]
        var data = headerString.joined(separator: "\r\n").data(using: .utf8)!
        
        data.append(contentsOf: fileData)
        data.append(contentsOf: "\r\n--\(boundary)--".data(using: .utf8)!)
        
        return data
    }
}

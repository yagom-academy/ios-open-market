//
//  Protocol.swift
//  OpenMarket
//
//  Created by 김민성 on 2021/05/20.
//

import Foundation

protocol URLProcessUsable {
    
    func setBaseURL(urlString: String) -> URL?
    
    func checkResponseCode(response: URLResponse?) -> Bool
    
}

protocol MultipartFormManagable {
    
    func convertFormField(name: String, value: String, boundary: String) -> String
    
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, boundary: String) -> Data
    
}

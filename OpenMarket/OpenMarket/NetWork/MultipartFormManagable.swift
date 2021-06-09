//
//  MultipartFormManagable.swift
//  OpenMarket
//
//  Created by 김민성 on 2021/06/08.
//

import Foundation

protocol MultipartFormManagable {
    func convertFormField(name: String, value: String, boundary: String) -> Data
    
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, boundary: String) -> Data
}

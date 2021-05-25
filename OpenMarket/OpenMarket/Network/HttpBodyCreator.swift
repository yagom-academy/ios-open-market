//
//  HttpBodyCreater.swift
//  OpenMarket
//
//  Created by steven on 2021/05/19.
//

import Foundation

struct HttpBodyCreator {
    let boundary: String
    let itemForm: ProductForm
    
    func make() -> Data {
        var data = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in itemForm.multiFormData {
            data.appendString(boundaryPrefix)
            data.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            data.appendString("\(value)\r\n")
        }
        for imageData in itemForm.images! {
            data.appendString(boundaryPrefix)
            data.appendString("Content-Disposition: form-data; name=\"images[]\"; filename=\"image.png\"\r\n")
            data.appendString("Content-Type: image/png\r\n\r\n")
            data.append(imageData)
            data.appendString("\r\n")
        }
        
        data.appendString("--".appending(boundary.appending("--")))
        
        return data
    }
}

//
//  MultiPartProtocol.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/20.
//

import Foundation

protocol MultiPartProtocol {
  func makeBodyForImage(boundary: String, parameter: String, images: [Data]) -> Data
  func makeBodyForNormal(boundary: String, parameter: String, value: Any?) -> Data
}

extension MultiPartProtocol {
  func makeBodyForImage(boundary: String, parameter: String, images: [Data]) -> Data {
    var data = Data()
    var imageIndex = 1
    
    images.forEach { image in
      data.appendString("--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"\(parameter)[]\"; filename=\"image\(imageIndex).png\"\r\n")
      data.appendString("Content-Type: image/png\r\n\r\n")
      data.append(image)
      data.appendString("\r\n")
      imageIndex += 1
    }

    return data
  }
  
  func makeBodyForNormal(boundary: String, parameter: String, value: Any?) -> Data {
    var data = Data()
            
    data.appendString("--\(boundary)\r\n")
    data.appendString("Content-Disposition: form-data; name=\"\(parameter)\"\r\n\r\n")
    if let value = value as? Int{
      data.appendString(String(value))
    } else if let value = value as? String {
      data.appendString(value)
    }
    data.appendString("\r\n")
    
    return data
  }
}


//
//  RestFulAPI.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/18.
//

import Foundation
import UIKit

protocol RestFulAPI {
  
}

extension RestFulAPI { 
  func createBody(json: Result<Data, NetworkError>, images: [UIImage], boundary: String) -> Data? {
    var body = Data()
    
    switch json {
    case .success(let data):
      body.append(makeApplicationJsonForm(name: "params", value: data, boundary: boundary))
      for image in images {
        guard let imageFile = makeImageFile(image: image) else {
          return nil
        }
        body.append(makeImageForm(image: imageFile, boundary: boundary))
      }
      body.appendString("--\(boundary)--\r\n")
    case .failure(let error):
      print(error)
    }
    
    return body
  }
  
  func makeApplicationJsonForm(name: String, value: Data, boundary: String) -> Data {
    var data = Data()
    data.appendString("--\(boundary)\r\n")
    data.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n")
    data.appendString("Content-Type: application/json\r\n\r\n")
    data.append(value)
    data.appendString("\r\n")
    
    return data
  }
  
  func makeImageForm(image: ImageFile, boundary: String) -> Data{
    var data = Data()
    data.appendString("--\(boundary)\r\n")
    data.appendString("Content-Disposition: form-data; name=\"images\"; filename=\"\(image.name)\(image.imageType.rawValue)\"\r\n")
    data.appendString("Content-Type: \(image.imageType.mime)\r\n\r\n")
    data.append(image.data)
    data.appendString("\r\n")
    
    return data
  }
  
  func makeImageFile(image: UIImage) -> ImageFile? {
    let name = UUID().uuidString
    guard let imageData = image.jpegData(compressionQuality: 1) else {
      return nil
    }
    return ImageFile(name: name, data: imageData, imageType: .jpeg)
  }
}

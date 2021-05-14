//
//  PostCreateArticle.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/14.
//

import Foundation
import UIKit

class PostCreateArticle {
    
    let getArticle = GetEssentialArticle()
    
    func convertFormField(name: String, value: String, boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"

        return fieldString
    }
    
    // 마지막 데이터 처리
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, boundary: String) -> Data {
        var data = Data()
         
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        data.append(fileData)
        data.append("\r\n".data(using: .utf8)!)
         
        return data
    }
    
    func postData(request: URLRequest, requestBody: Data) {
        // URLSession 객체를 통해 전송, 응답값 처리
        URLSession.shared.uploadTask(with: request, from: requestBody) { (data, response, error) in

            if let error = error {
                print("에러")
                return
            }
            
            if self.getArticle.checkResponseCode(response: response) {
                print("응답코드 에러")
            }
            else {
                print("성공")
            }
        }.resume()
    }
    
}

extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
          self.append(data)
        }
  }
}

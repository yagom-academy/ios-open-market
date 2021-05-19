//
//  PostCreateArticle.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/14.
//

import Foundation
import UIKit

class PostCreateArticle {
    
    let manageMultipartForm = ManageMultipartForm()
    let urlProcess = URLProcess()
    
    func postData(urlRequest: URLRequest?, requestBody: Data, completion: @escaping (Bool) -> Void) {
        guard let request = urlRequest else { return }
        
        URLSession.shared.uploadTask(with: request, from: requestBody) { (data, response, error) in

            if error != nil { return }
            if self.urlProcess.checkResponseCode(response: response) {
                print("post성공")
                completion(true)
            }
            else {
                print("post 보내기 실패")
                completion(false)
            }
        }.resume()
    }
    
    func makeRequestBody(formdat: CreateArticle, boundary: String, imageData: Data) -> Data {
        var httpBody = Data()
        
        httpBody.appendString(manageMultipartForm.convertFormField(name: "title", value: formdat.title, boundary: boundary))
        httpBody.appendString(manageMultipartForm.convertFormField(name: "descriptions", value: formdat.descriptions, boundary: boundary))
        httpBody.appendString(manageMultipartForm.convertFormField(name: "price", value: "\(formdat.price)", boundary: boundary))
        httpBody.appendString(manageMultipartForm.convertFormField(name: "currency", value: formdat.currency, boundary: boundary))
        httpBody.appendString(manageMultipartForm.convertFormField(name: "stock", value: "\(formdat.stock)", boundary: boundary))
        httpBody.appendString(manageMultipartForm.convertFormField(name: "discounted_price", value: "\(formdat.discountedPrice!)", boundary: boundary))
        httpBody.append(manageMultipartForm.convertFileData(fieldName: "images[]", fileName: "github.png", mimeType: "image/png", fileData: imageData, boundary: boundary))
        httpBody.appendString(manageMultipartForm.convertFormField(name: "password", value: formdat.password, boundary: boundary))
        httpBody.appendString("--\(boundary)--")
        
        return httpBody
    }
    
}

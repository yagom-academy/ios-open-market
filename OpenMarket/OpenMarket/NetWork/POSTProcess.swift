//
//  POSTProcess.swift
//  OpenMarket
//
//  Created by 김민성 on 2021/06/08.
//

import Foundation

class POSTProcess {
    private let commonURLProcess: URLProcessUsable
    private let urlSession: URLSession
    private let multipartFormManager: MultipartFormManagable
    
    init(commonURLProcess: URLProcessUsable, urlSession: URLSession = .shared, multipartFromManager: MultipartFormManagable) {
        self.commonURLProcess = commonURLProcess
        self.urlSession = urlSession
        self.multipartFormManager = multipartFromManager
    }
    
    func uploadData(urlRequest: URLRequest?, requestBody: Data, completionHandler: @escaping (Bool) -> Void) {
        guard let request = urlRequest else { return }
        
        urlSession.uploadTask(with: request, from: requestBody) { (data, response, error) in
            if error != nil { return }
            
            guard let response = response as? HTTPURLResponse,
                  (200...399).contains(response.statusCode) else {
                print("post 보내기 실패")
                completionHandler(false)
                return
            }
            print("post성공")
            completionHandler(true)
        }.resume()
    }
    
    func makeRequestBody(formData: PostProductData, boundary: String, fileName: String, imageData: Data) -> Data {
        var httpBody = Data()
        
        httpBody.append(multipartFormManager.convertFormField(name: "title", value: formData.title, boundary: boundary))
        httpBody.append(multipartFormManager.convertFormField(name: "descriptions", value: formData.descriptions, boundary: boundary))
        httpBody.append(multipartFormManager.convertFormField(name: "price", value: "\(formData.price)", boundary: boundary))
        httpBody.append(multipartFormManager.convertFormField(name: "currency", value: formData.currency, boundary: boundary))
        httpBody.append(multipartFormManager.convertFormField(name: "stock", value: "\(formData.stock)", boundary: boundary))
        httpBody.append(multipartFormManager.convertFormField(name: "discounted_price", value: "\(formData.discountedPrice!)", boundary: boundary))
        httpBody.append(multipartFormManager.convertFileData(fieldName: "images[]", fileName: fileName, mimeType: "img/png", fileData: imageData, boundary: boundary))
        httpBody.append(multipartFormManager.convertFormField(name: "password", value: formData.password, boundary: boundary))
        httpBody.append(contentsOf: "\r\n--\(boundary)--".data(using:.utf8)!)
        
        return httpBody
    }
    
}

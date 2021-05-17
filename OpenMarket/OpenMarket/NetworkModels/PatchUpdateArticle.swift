//
//  PatchUpdateArticle.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/14.
//

import Foundation

class PatchUpdateArticle {
    let manageMultipartForm = ManageMultipartForm()
    
    func updateRequestBody(boundary: String, imageData: Data) -> Data {
        // Text 데이터
        var httpBody = Data()
        
        httpBody.appendString(manageMultipartForm.convertFormField(name: "title", value: "맥북M1 - 바비", boundary: boundary))
        httpBody.appendString(manageMultipartForm.convertFormField(name: "descriptions", value: "바비의 맥북", boundary: boundary))
        httpBody.appendString(manageMultipartForm.convertFormField(name: "price", value: "123456789", boundary: boundary))
        httpBody.appendString(manageMultipartForm.convertFormField(name: "currency", value: "KRW", boundary: boundary))
        httpBody.appendString(manageMultipartForm.convertFormField(name: "stock", value: "1", boundary: boundary))
        httpBody.appendString(manageMultipartForm.convertFormField(name: "discounted_price", value: "1234567", boundary: boundary))
        httpBody.appendString(manageMultipartForm.convertFormField(name: "password", value: "1234567", boundary: boundary))
        httpBody.append(manageMultipartForm.convertFileData(fieldName: "images[]", fileName: "github.png", mimeType: "image/png", fileData: imageData, boundary: boundary))
        httpBody.appendString("--\(boundary)--")
        
        return httpBody
    }
    
}

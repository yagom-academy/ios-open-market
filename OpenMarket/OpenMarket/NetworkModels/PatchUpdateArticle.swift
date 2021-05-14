//
//  PatchUpdateArticle.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/14.
//

import Foundation

class PatchUpdateArticle {
    let postCreateArticle = PostCreateArticle()
    
    func updateRequestBody(boundary: String, imageData: Data) -> Data {
        // Text 데이터
        var httpBody = Data()
        
        httpBody.append(postCreateArticle.convertFormField(name: "title", value: "맥북M1 - 512", boundary: boundary).data(using: .utf8)!)
        httpBody.append(postCreateArticle.convertFormField(name: "descriptions", value: "수킴의 맥북", boundary: boundary).data(using: .utf8)!)
        httpBody.append(postCreateArticle.convertFileData(fieldName: "images[]", fileName: "github.png", mimeType: "image/png", fileData: imageData, boundary: boundary))
        httpBody.append(postCreateArticle.convertFormField(name: "password", value: "1234", boundary: boundary).data(using: .utf8)!)
        httpBody.append("--\(boundary)--".data(using: .utf8)!)
        
        return httpBody
    }
    
}

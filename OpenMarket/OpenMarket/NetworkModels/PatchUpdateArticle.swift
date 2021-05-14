//
//  PatchUpdateArticle.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/14.
//

import Foundation

class PatchUpdateArticle {
    let postCreateArticle = PostCreateArticle()
    
    func updateRequestBody(boundary: String) -> Data {
        // Text 데이터
        var httpBody = Data()
        
        httpBody.append(postCreateArticle.convertFormField(name: "title", value: "김우승", boundary: boundary).data(using: .utf8)!)
        httpBody.append(postCreateArticle.convertFormField(name: "descriptions", value: "성경인", boundary: boundary).data(using: .utf8)!)
        httpBody.append(postCreateArticle.convertFormField(name: "password", value: "1234", boundary: boundary).data(using: .utf8)!)
        httpBody.append("--\(boundary)--".data(using: .utf8)!)
        
        return httpBody
    }
    
}

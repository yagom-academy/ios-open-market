//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let getArticle = GetEssentialArticle()
        let postArticle = PostCreateArticle()
        
        getArticle.getParsing()
        
        let profileImage:UIImage = UIImage(named:"github")!
        let imageData:Data = profileImage.pngData()!
        
        
        let url = URL(string: "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/C0392506-1D33-4755-8509-C09DC37822AA.png")
        var image: UIImage?
        
        let data = try? Data(contentsOf: url!)
        
        
        // UUID로 고유 식별자 추출
        let yagomBoundary = "Boundary-\(UUID().uuidString)"
        
        // URL 객체 정의
        guard let yagomURL = URL(string: "https://camp-open-market-2.herokuapp.com/item") else { print("yagomURL에러"); return }
        
        // Text 데이터
        var httpBody = Data()
        
        httpBody.append(postArticle.convertFormField(name: "title", value: "김우승", boundary: yagomBoundary).data(using: .utf8)!)
        httpBody.append(postArticle.convertFormField(name: "descriptions", value: "성경인", boundary: yagomBoundary).data(using: .utf8)!)
        httpBody.append(postArticle.convertFormField(name: "price", value: "수킴", boundary: yagomBoundary).data(using: .utf8)!)
        httpBody.append(postArticle.convertFormField(name: "currency", value: "USD", boundary: yagomBoundary).data(using: .utf8)!)
        httpBody.append(postArticle.convertFormField(name: "stock", value: "214", boundary: yagomBoundary).data(using: .utf8)!)
        httpBody.append(postArticle.convertFormField(name: "discounted_price", value: "2420", boundary: yagomBoundary).data(using: .utf8)!)
        httpBody.append(postArticle.convertFileData(fieldName: "images[]", fileName: "github.png", mimeType: "image/png", fileData: imageData, boundary: yagomBoundary))
        httpBody.append(postArticle.convertFormField(name: "password", value: "1234", boundary: yagomBoundary).data(using: .utf8)!)
        httpBody.append("--\(yagomBoundary)--".data(using: .utf8)!)
        
        
        // URLRequest 객체를 정의
        var request = URLRequest(url: yagomURL)
        request.httpMethod = "POST"
        
        // HTTP 메시지 헤더
        request.setValue("multipart/form-data; boundary=\(yagomBoundary)", forHTTPHeaderField: "Content-Type")
        
        postArticle.postData(request: request, requestBody: httpBody)
    }
}

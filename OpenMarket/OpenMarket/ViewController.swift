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
        let urlProcess = URLProcess()
        
        getArticle.getParsing()
        
        let pngImage = convertDataToAssetImage(imageName: "github")
        
        
        // UUID로 고유 식별자 추출
        let yagomBoundary = "Boundary-\(UUID().uuidString)"
        
        // Text 데이터
        var httpBody = Data()
        
        httpBody.append(postArticle.convertFormField(name: "title", value: "김우승", boundary: yagomBoundary).data(using: .utf8)!)
        httpBody.append(postArticle.convertFormField(name: "descriptions", value: "성경인", boundary: yagomBoundary).data(using: .utf8)!)
        httpBody.append(postArticle.convertFormField(name: "price", value: "수킴", boundary: yagomBoundary).data(using: .utf8)!)
        httpBody.append(postArticle.convertFormField(name: "currency", value: "USD", boundary: yagomBoundary).data(using: .utf8)!)
        httpBody.append(postArticle.convertFormField(name: "stock", value: "214", boundary: yagomBoundary).data(using: .utf8)!)
        httpBody.append(postArticle.convertFormField(name: "discounted_price", value: "2420", boundary: yagomBoundary).data(using: .utf8)!)
        httpBody.append(postArticle.convertFileData(fieldName: "images[]", fileName: "github.png", mimeType: "image/png", fileData: pngImage, boundary: yagomBoundary))
        httpBody.append(postArticle.convertFormField(name: "password", value: "1234", boundary: yagomBoundary).data(using: .utf8)!)
        httpBody.append("--\(yagomBoundary)--".data(using: .utf8)!)
        
        
        guard let request = urlProcess.setURLRequest(requestMethodType: "POST", boundary: yagomBoundary) else { return }

        postArticle.postData(request: request, requestBody: httpBody)
    }
    
    func convertDataToAssetImage(imageName: String) -> Data {
        let profileImage:UIImage = UIImage(named: imageName)!
        let imageData:Data = profileImage.pngData()!
        
        return imageData
    }
    
    func convertDataToURLImage(imageURL: String) -> Data {
        let url = URL(string: imageURL)
        var image: UIImage?
        
        let data = try? Data(contentsOf: url!)
        
        return data!
    }
}

//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlProcess = URLProcess()
        
        // UUID로 고유 식별자 추출
        let yagomBoundary = "Boundary-\(UUID().uuidString)"
        
        // MARK - GET메소드로 정보조회하기 -> 데이터 추출 escaping closure
//        let getEssentialArticle = GetEssentialArticle()
//        
//        getEssentialArticle.getParsing { (testParam: EntireArticle) in
//            print(testParam.page)
//            print(testParam.items.first?.title)
//        }
        
        // MARK - POST메소드 정보보내기
        let postCreateArticle = PostCreateArticle()
        let pngImage = postCreateArticle.manageMultipartForm.convertDataToAssetImage(imageName: "github")
        
        
//        let createArticle: CreateArticle = CreateArticle(title: "귀마개", descriptions: "싸구려", price: 15326, currency: "KRW", stock: 15, discountedPrice: 222, images: [pngImage], password: "1234")
//
//        let postRequest = urlProcess.setURLRequest(requestMethodType: "POST", boundary: yagomBoundary)
//        let postRequestBody = postCreateArticle.makeRequestBody(formdat: createArticle ,boundary: yagomBoundary, imageData: pngImage)
//        postCreateArticle.postData(urlRequest: postRequest, requestBody: postRequestBody)

        // MARK - PATCH메소드 정보수정하기
        let patchUpdateArticle = PatchUpdateArticle()

        let updateArticle: UpdateArticle = UpdateArticle(title: "쭈구미", descriptions: "싸구려", price: 15326, currency: "KRW", stock: 15, discountedPrice: 222, images: [pngImage], password: "1234")
        
        let patchRequest = urlProcess.setURLRequest(requestMethodType: "PATCH", boundary: yagomBoundary)
        let patchRequestBody = patchUpdateArticle.updateRequestBody(formdat: updateArticle,boundary: yagomBoundary, imageData: pngImage)
        postCreateArticle.postData(urlRequest: patchRequest, requestBody: patchRequestBody)

        
        // MARK - DELETE메소드 정보삭제하기
//        let deleteArticle = DeleteArticle()
//
//        deleteArticle.encodePassword(password: "123")
        
    }
    

}

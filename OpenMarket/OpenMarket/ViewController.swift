//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // GET메소드로 정보조회하기
        let getEssentialArticle = GetEssentialArticle()
        
        getEssentialArticle.getParsing()
        
        
        //getArticle.getParsing()
        
//        let pngImage = convertDataToAssetImage(imageName: "github")
//
//
//        // UUID로 고유 식별자 추출
//        let yagomBoundary = "Boundary-\(UUID().uuidString)"
//
//        let httpBody = postArticle.makeRequestBody(boundary: yagomBoundary, imageData: pngImage)
//        let updateBody = patchArticle.updateRequestBody(boundary: yagomBoundary, imageData: pngImage)
//
//        guard let request = urlProcess.setURLRequest(requestMethodType: "PATCH", boundary: yagomBoundary) else { return }
//
//        postArticle.postData(request: request, requestBody: updateBody)
    }
    

}

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
        let postCreateArticle = PostCreateArticle()
        
        let yagomBoundary = "Boundary-\(UUID().uuidString)"
        let pngImage = convertDataToAssetImage(imageName: "github")
        guard let baseUrl = urlProcess.setBaseURL(urlString: "https://camp-open-market-2.herokuapp.com/") else { return }
        guard let httpURL = urlProcess.setUserActionURL(baseURL: baseUrl, userAction: .addArticle) else { return }
        
        let createArticle = CreateArticle(title: "귀마개", descriptions: "싸구려", price: 15326, currency: "KRW", stock: 15, discountedPrice: 222, images: [pngImage], password: "1234")

        let postRequest = urlProcess.setURLRequest(url: urlProcess.setUserActionURL(baseURL: httpURL, userAction: .addArticle)!, userAction: .addArticle, boundary: yagomBoundary)
        
        postCreateArticle.postData(urlRequest: postRequest!, requestBody: postCreateArticle.makeRequestBody(formdat: createArticle, boundary: yagomBoundary, imageData: pngImage))

    }
    func convertDataToAssetImage(imageName: String) -> Data {
        let profileImage:UIImage = UIImage(named: imageName)!
        let imageData:Data = profileImage.pngData()!
        
        return imageData
    }

}

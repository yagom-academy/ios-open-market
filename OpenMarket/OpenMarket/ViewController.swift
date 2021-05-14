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
        let patchArticle = PatchUpdateArticle()
        
        
        //getArticle.getParsing()
        
        let pngImage = convertDataToAssetImage(imageName: "github")
        
        
        // UUID로 고유 식별자 추출
        let yagomBoundary = "Boundary-\(UUID().uuidString)"
        
        let httpBody = postArticle.makeRequestBody(boundary: yagomBoundary, imageData: pngImage)
        //let updateBody = patchArticle.updateRequestBody(boundary: yagomBoundary)
        
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

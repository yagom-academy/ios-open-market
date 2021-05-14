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
        let deleteArticle = DeleteArticle()
        
        let ones = PasswordArticle(password: "1234")
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(ones)
            print(String(data: data, encoding: .utf8)!)
            
            guard let baseURL = URL(string: "https://camp-open-market-2.herokuapp.com/item/123") else { return }
            
            var request = URLRequest(url: baseURL)
            request.httpMethod = "DELETE"
            // HTTP 메시지 헤더
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                print("ㅆㅆㅆㅆ")
            }.resume()
            
        } catch {
            print(error)
        }
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

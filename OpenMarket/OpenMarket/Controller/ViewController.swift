//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    let networkManager = NetworkManager(session: URLSession.shared)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* GET 요청
        let api = GetItemsAPI(page: 3)
        networkManager.commuteWithAPI(with: api) { result in
            if case .success(let data) = result {
                guard let product = try? JSONDecoder().decode(Items.self, from: data) else {
                    return
                }
                print(product)
            }
        }
        */
        
        /* POST 요청
        let param = POSTItem(title: "줄무늬전갱이초밥", descriptions: "시마아지라고 부르죠", price: 9000, currency: "WON", stock: 5, discounted_price: 6000, password: "12345").parameter()
        guard let image = Media(imageName: "시마아지", mimeType: .png, image: #imageLiteral(resourceName: "1f363")) else { return }
        let api = PostItemAPI(parameters: param, images: [image])
        
        networkManager.commuteWithAPI(with: api) { _ in
        }
        */
        
        /* PATCH 요청
        let param = PATCHItem(title: "시마아지스시(수정)", descriptions: "하나 주세요", price: 10000, currency: "WON", stock: 4, discounted_price: 7000, password: "12345").parameter()
        let api = PatchItemAPI(id: 641, parameters: param, images: nil)
        
        networkManager.commuteWithAPI(with: api) { _ in
        }
        */
        
        
        
        // Do any additional setup after loading the view.
    }
}


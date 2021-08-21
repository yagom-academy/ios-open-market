//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let networkManager = NetworkManager()
        
        //GETItem Test
                networkManager.commuteWithAPI(API: GetItemAPI(id: 559)) { _ in
                }
        //GETItems Test
//        networkManager.commuteWithAPI(API: GetItemsAPI(page: 1)) { _ in
//        }
        //
        //POST Test
        //                let postItem = PostItemData(title: "예스코치초밥", descriptions: "테스트 잘되라", price: 100000000, currency: "won", stock: 1, password: "12345")
        //                guard let media = Media(image: #imageLiteral(resourceName: "1f363"), mimeType: .png) else { return }
        //
        //                networkManager.commuteWithAPI(API: PostAPI(parameter: postItem.parameter(), items: [media])) { _ in
        //                }
        //
        //        //PATCH Test
        //        let patchItem = PatchItemData(title: "테스트2" , password: "12345").parameter()
        //        networkManager.commuteWithAPI(API: PatchAPI(id: 557, parameter: patchItem, items: nil)) { _ in
        //
        //        }
        //
        //        //DELETE Test
        //        networkManager.commuteWithAPI(API: DeleteAPI(id: 556, password: "12345")) { _ in
        //
        //        }
    }
}

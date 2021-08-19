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

        //GET Test
//        networkManager.commuteWithAPI(API: GetItemAPI(id: 411)) { result in
//            print(result)
//        }
//
        //POST Test
        let postItem = PostItemData(title: "예스코치초밥", descriptions: "테스트 잘되라", price: 100000000, currency: "won", stock: 1, password: "12345")
        guard let media = Media(image: #imageLiteral(resourceName: "1f363"), mimeType: .png) else { return }
        
        networkManager.commuteWithAPI(API: PostAPI(parameter: postItem.parameter(), items: [media])) { result in
            print(result)
        }
        
        

        //PATCH Test
//        let patchItem = PatchItemData(title: "테스트2" , password: "12345")
//        NetworkManager.init().patchItem(item: patchItem, id: "485")

        //DELETE Test
//        NetworkManager.init().deleteItem(id: "485", password: "12345")

    }
}


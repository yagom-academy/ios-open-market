//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //GET Test
        NetworkManager.init().getItems(page: "13")
//        NetworkManager.init().getItem(id: "484")
        
        //POST Test
//        let postItem = PostItemData(title: "테스트", descriptions: "테스트 잘되라", price: 100000000, currency: "won", stock: 1, password: "12345")
//        NetworkManager.init().postItem(item: postItem)
        
        //PATCH Test
//        let patchItem = PatchItemData(title: "테스트2" , password: "12345")
//        NetworkManager.init().patchItem(item: patchItem, id: "485")
        
        //DELETE Test
//        NetworkManager.init().deleteItem(id: "485", password: "12345")

        
    
    }
}


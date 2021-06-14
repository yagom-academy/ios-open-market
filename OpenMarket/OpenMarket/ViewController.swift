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
        let dataLoader = DataLoader(commonURLProcess: CommonURLProcess())

        dataLoader.startLoad(index: "1") { (testParam: Result<GetProductList.Item, Error>) in
            switch testParam {
            case .success(let post):
                print(post.title)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
}

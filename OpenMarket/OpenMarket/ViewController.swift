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
        
        var getProcess = GETProcess(commonURLProcess: CommonURLProcess())
        
        getProcess.dataParsing(index: "55") { (testParam: Result<OpenMarketProductList.Item, Error>) in
            switch testParam {
            case .success(let post):
                print(post.title)
            case .failure(let error):
                print("데이터가 없습니다.")
            }
        }
    }
}

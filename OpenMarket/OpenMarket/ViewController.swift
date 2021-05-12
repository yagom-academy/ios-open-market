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
        
        let test = JsonDecoder()
        let data = try! test.jsonDataLoad(dataName: "Items")
        
        let parsingData = test.jsonDecode(data: data, modelType: ItemList.self)
        print(parsingData)
    }


}


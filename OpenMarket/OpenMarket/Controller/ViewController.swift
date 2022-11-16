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
        let urlManager = URLSessionManager()
        urlManager.getItemsPerPage { result in
            switch result {
            case .success(let data):
                JSONDataManager.decodeData(data: data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


}


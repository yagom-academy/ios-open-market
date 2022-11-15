//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let networkManager: NetworkManager = NetworkManager(session: URLSession(configuration: .default))
        guard let url = URL(string: "https://openmarket.yagom-academy.kr/healthChecker") else { return }
        let urlRequest = URLRequest(url: url)
        
        networkManager.checkAPIHealth(request: urlRequest) { result in
            switch result {
            case .success(let data):
                print("성공")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


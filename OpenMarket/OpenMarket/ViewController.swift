//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let baseUrl = URL(string: "https://camp-open-market-2.herokuapp.com/items/1") else { return }
//
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//        let dataTask = session.dataTask(with: baseUrl) { (data, response, error) in
//            guard error == nil else {
//                return }
//            guard let successResoponse = (response as? HTTPURLResponse)?.statusCode else { return }
//
//            if successResoponse >= 200 && successResoponse < 300 {
//                guard let resultData = data else { return }
//
//                do {
//                    let decoder = JSONDecoder()
//                    let parsingData = try decoder.decode(EntireArticle.self, from: resultData)
//
//                    let items = parsingData.items
//
//                    print("\(items.first?.title)")
//                } catch {
//                    print("에러")
//                }
//            } else {
//                return
//            }
//        }
//        dataTask.resume()
    }
}

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
        
        // MARK: --- TEST 코드 입니다
//        let manager = NetworkingManager(session: URLSession.shared, parsingManager: ParsingManager())
//        let api = RequestAPI(method: .get, path: NetworkingManager.OpenMarketInfo.getList.makePath(suffix: 1))
//        do {
//            let request = try manager.configureRequest(from: api)
//            manager.request(bundle: request) { result in
//                switch result {
//                case .success(let data):
//                    do {
//                        let decodeResult = ParsingManager().parse(data, to: ItemBundle.self)
//                        print(decodeResult)
//                    } catch {
//                        print("실패요")
//                    }
//                case .failure(_):
//                    print("실패요")
//                }
//            }
//        } catch {
//
//        }
    }
}


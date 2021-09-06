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
        let networkManager = NetworkManager(session: URLSession.shared)

        let param = POSTItem(title: "초밥", descriptions: "스시", price: 9000, currency: "WON", stock: 5, discountedPrice: 6000, password: "12345").parameter()
        guard let image = Media(imageName: "시마아지", mimeType: .png, image: #imageLiteral(resourceName: "1f363")) else { return }
        let api = PostItemAPI(parameters: param, images: [image])

        networkManager.commuteWithAPI(with: api) { _ in
            print("전송완료")
        }

    }
}

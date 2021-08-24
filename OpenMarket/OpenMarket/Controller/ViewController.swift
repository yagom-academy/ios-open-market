//
//  OpenMarket - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Session().deleteItem(itemId: 539, item: dummy) { result in
//            switch result {
//            case .success(let itemDetail):
//               print(itemDetail)
//            case .failure(let error):
//               print(error)
//            }
//        }

        
//        undesirableTest()
    }
}


extension ViewController {
    func undesirableTest(){
        
        let session = NetworkManager()
        
        let pageIndex: UInt = 17
        let itemIndexWhichIsExist: UInt = 43
        let itemIndexWhichIsNotExist: UInt = 9999
        
        session.getItems(pageIndex: pageIndex) { result in
            print("")
            switch result {
            case .success(let itemList):
                print("lists: \(itemList)")
            case .failure(let error):
                print(error)
            }
        }

        session.getItem(id: itemIndexWhichIsExist) { result in
            print("")
            switch result {
            case .success(let item):
                print("item be existed: \(item)")
            case .failure(let error):
                print(error)
            }
        }

        session.getItem(id: itemIndexWhichIsNotExist) { result in
            print("")
            switch result {
            case .success(let item):
                print("item be not existed: \(item)")
            case .failure(let error):
                print(error)
            }
        }
    }
}


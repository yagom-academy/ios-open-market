//
//  OpenMarket - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        undesirable Test()
    }
}


extension ViewController {
    func undesirableTest(){
        
        let session = Session()
        
        let pageIndex: UInt = 1
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


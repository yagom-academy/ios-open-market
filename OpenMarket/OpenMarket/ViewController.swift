//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var segmentSwitch: UISegmentedControl!
    
    let jsonParser = JSONParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProuctData()
    }
    
    @IBAction func switchView(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        switch sender.selectedSegmentIndex {
        case 0:
            segmentSwitch.backgroundColor = .yellow
        case 1:
            segmentSwitch.backgroundColor = .blue
        default:
            break
        }
    }
    
    func getProuctData() {
        jsonParser.dataTask(by: URLCollection.productListInquery, completion: { (response) in
            switch response {
            case .success(let data):
                self.getProuctList(data)
            case .failure(let data):
                print(data)
            }
        })
    }
    
    func getProuctList(_ data: ProductListResponse) {
        print(data.pageNo)
        print(data.itemsPerPage)
        print(data.totalCount)
        print(data.offset)
        print(data.limit)
        print(data.pages[0].id)
        print(data.pages[0].vendorId)
        print(data.pages[0].name)
        print(data.pages[0].thumbnail)
        print(data.pages[0].currency)
        print(data.pages[0].price)
        print(data.pages[0].bargainPrice)
        print(data.pages[0].discountedPrice)
        print(data.pages[0].stock)
        print(data.pages[0].createdAt)
        print(data.pages[0].issuedAt)
    }
}

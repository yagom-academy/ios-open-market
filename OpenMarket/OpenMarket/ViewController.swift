//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var segmentSwitch: UISegmentedControl!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    
    let jsonParser = JSONParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func switchView(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        switch sender.selectedSegmentIndex {
        case 0:
            // segmentSwitch.backgroundColor = .yellow
            firstView.alpha = 1
            secondView.alpha = 0
        case 1:
            // segmentSwitch.backgroundColor = .blue
            firstView.alpha = 0
            secondView.alpha = 1
        default:
            break
        }
    }
}

class FirstViewController: UIViewController {
    let jsonParser = JSONParser()
    var productData: ProductListResponse?
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
        getProuctData()
        print("--------------")
        print(productData)
    }
    
    func getProuctData() {
        jsonParser.dataTask(by: URLCollection.productListInquery, completion: { (response) in
            switch response {
            case .success(let data):
                // print(data)
                self.productData = data

            case .failure(let data):
                print(data)
            }
        })
        print(self.productData)

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

extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        jsonParser.dataTask(by: URLCollection.productListInquery, completion: { (response) in
            switch response {
            case .success(let data):
                // print(data)
                DispatchQueue.main.async {
                    self.productData = data
                    cell.myLabel.text = "Hi Collection Label \(indexPath.row), \(self.productData?.pages[indexPath.row].name)"
                }
            case .failure(let data):
                print(data)
            }
        })

        return cell
    }
}

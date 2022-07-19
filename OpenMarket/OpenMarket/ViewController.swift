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
        switch sender.selectedSegmentIndex {
        case 0:
            firstView.alpha = 1
            secondView.alpha = 0
        case 1:
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
    
    var dataStore: [ProductListResponse] = []
    
    let URLSemaphore = DispatchSemaphore(value: 0)
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        self.setData()
        
    }
    
    func setData() {
        jsonParser.dataTask(by: URLCollection.productListInquery, completion: { (response) in
            switch response {
            case .success(let data):
                self.productData = data
                self.dataStore = [data]
                self.URLSemaphore.signal()
            case .failure(let data):
                print(data)
            }
        })
        URLSemaphore.wait()
    }
}

extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataStore[0].pages.count
    }
    
    func makeImage(thumbnail: String) -> UIImage? {
        if thumbnail.isEmpty || thumbnail.count == 0 {
            return nil
        }
        
        do {
            let url = URL(string: thumbnail)
            if url != nil {
                let data = try Data(contentsOf: url!)
                return UIImage(data: data)
            }
        } catch {
            print(CustomError.unkownError)
        }
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        cell.productImage.image = makeImage(thumbnail: dataStore[0].pages[indexPath.row].thumbnail)
        cell.productName.text = dataStore[0].pages[indexPath.row].name
        cell.productPrice.text = "\(dataStore[0].pages[indexPath.row].price)"
        
        return cell
    }
}

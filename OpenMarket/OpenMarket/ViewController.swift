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
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
    }
}

extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
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
        
        jsonParser.dataTask(by: URLCollection.productListInquery, completion: { (response) in
            switch response {
            case .success(let data):
                DispatchQueue.main.async {
                    self.productData = data
                    guard let decodedata = self.productData else { return }
                    
                    cell.productName.text = decodedata.pages[indexPath.row].name
                }
                
            case .failure(let data):
                print(data)
            }
        })
        
        return cell
    }
}

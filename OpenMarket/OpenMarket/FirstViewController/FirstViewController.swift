//
//  FirstViewController.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/19.
//

import UIKit

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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
        guard let imageURL: URL = URL(string: dataStore[0].pages[indexPath.row].thumbnail) else { return cell }
        guard let imageData: Data = try? Data(contentsOf: imageURL) else { return cell }

        cell.productImage.image = UIImage(data: imageData)
        cell.productName.text = dataStore[0].pages[indexPath.row].name
        cell.productPrice.text = "\(dataStore[0].pages[indexPath.row].price)"
        
        return cell
    }
}

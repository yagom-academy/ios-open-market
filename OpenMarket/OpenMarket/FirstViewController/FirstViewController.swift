//
//  FirstViewController.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/19.
//

import UIKit

@available(iOS 14.0, *)
class FirstViewController: UIViewController {
    let jsonParser = JSONParser()
    let URLSemaphore = DispatchSemaphore(value: 0)
    var productData: ProductListResponse?

    @IBOutlet weak var productCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        productCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
//        self.productCollectionView.setCollectionViewLayout(<#T##layout: UICollectionViewLayout##UICollectionViewLayout#>, animated: <#T##Bool#>)
        self.setData()
    }
    
    func getLayout() -> UICollectionViewCompositionalLayout {
        
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    func setData() {
        jsonParser.dataTask(by: URLCollection.productListInquery, completion: { (response) in
            switch response {
            case .success(let data):
                self.productData = data
                self.URLSemaphore.signal()
            case .failure(let data):
                print(data)
            }
        })
        URLSemaphore.wait()
    }
}

@available(iOS 14.0, *)
extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let result = productData else { return 0 }
        return result.itemsPerPage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        guard let result = productData,
              let imageURL: URL = URL(string: result.pages[indexPath.row].thumbnail),
              let imageData: Data = try? Data(contentsOf: imageURL) else {
            return cell
        }

        cell.productImage.image = UIImage(data: imageData)
        cell.productName.text = result.pages[indexPath.row].name
        cell.productPrice.text = "\(result.pages[indexPath.row].price)"
        
        return cell
    }
}

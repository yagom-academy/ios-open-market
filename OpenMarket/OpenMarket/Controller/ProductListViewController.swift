//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ProductListViewController: UIViewController {
    @IBOutlet weak var openMarketCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.openMarketCollectionView.dataSource = self
        openMarketCollectionView.register(UINib(nibName: "OpenMarketItemCell", bundle: nil), forCellWithReuseIdentifier: "OpenMarketItemCell")
        // Do any additional setup after loading the view.
    }


}
extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OpenMarketItemCell", for: indexPath)
        guard let customCell = cell as? OpenMarketItemCell else {
            return cell
        }
        return customCell
    }
}


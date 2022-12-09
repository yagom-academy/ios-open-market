//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by Mangdi on 2022/12/09.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    var productID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.decelerationRate = .fast
        collectionView.register(UINib(nibName: "CustomCollectionViewPageCell", bundle: nil), forCellWithReuseIdentifier: "customCollectionViewPageCell")
        collectionView.collectionViewLayout = collectionViewFlowLayout
        collectionView.showsHorizontalScrollIndicator = false
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.itemSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        collectionViewFlowLayout.minimumLineSpacing = 0
    }
}

extension ProductDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionViewPageCell", for: indexPath) as? CustomCollectionViewPageCell ?? CustomCollectionViewPageCell()
        return customCell
    }
}

//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let openMarketDataSource = OpenMarketDataSource()
   
    private let compositionalLayout = CompositionalLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        collectionView.dataSource = openMarketDataSource
//        collectionView.delegate = self
        collectionView.register(UINib(nibName: ProductCell.listNibName, bundle: nil), forCellWithReuseIdentifier: ProductCell.identifier)
//        collectionView.register(UINib(nibName: ProductCell.GridNibName, bundle: nil), forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.collectionViewLayout = compositionalLayout.creat(horizontalNumber: 1, verticalSize: 100, scrollDirection: .vertical)
        openMarketDataSource.requestProductList(collectionView: collectionView)
    }
}

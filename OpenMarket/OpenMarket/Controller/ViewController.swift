//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let test1 = OpenMarketDataSource.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = test1
        let layout = Layout.generate(self.view)
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
}


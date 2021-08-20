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
        collectionView.collectionViewLayout = layout()
        collectionView.reloadData()
    }
    
    
    func layout() -> UICollectionViewFlowLayout {
        let flow = UICollectionViewFlowLayout()
        flow.minimumLineSpacing = 10
        flow.minimumInteritemSpacing = 10
        flow.itemSize = CGSize(width: 200, height: 200)
        return flow
    }
}


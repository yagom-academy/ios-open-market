//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentCotrol: UISegmentedControl!
    
    @IBAction func onCollectionViewTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            collectionView.collectionViewLayout = compositionalLayout.creat(horizontalNumber: 1, verticalSize: 100, scrollDirection: .vertical)
        case 1:
            collectionView.collectionViewLayout = compositionalLayout.creat(horizontalNumber: 2, verticalSize: 300, scrollDirection: .vertical)
        default:
            break
        }
    }
    private let openMarketDataSource = OpenMarketDataSource()
    private let compositionalLayout = CompositionalLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        collectionView.dataSource = openMarketDataSource
//        collectionView.delegate = self
        collectionView.register(UINib(nibName: ProductCell.listNibName, bundle: nil), forCellWithReuseIdentifier: ProductCell.listIdentifier)
        collectionView.register(UINib(nibName: ProductCell.gridNibName, bundle: nil), forCellWithReuseIdentifier: ProductCell.gridItentifier)
        collectionView.collectionViewLayout = compositionalLayout.creat(horizontalNumber: 1, verticalSize: 100, scrollDirection: .vertical)
        openMarketDataSource.requestProductList(collectionView: collectionView)
        segmentCotrol.addTarget(self, action: #selector(changeViewMode), for: .valueChanged)
    }
    
    @objc func changeViewMode() {
        if openMarketDataSource.viewMode.type == .grid {
            openMarketDataSource.viewMode.type = .list
        } else {
            openMarketDataSource.viewMode.type = .grid
        }
        collectionView.reloadData()
    }
}

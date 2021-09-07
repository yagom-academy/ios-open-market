//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private let openMarketDataSource = OpenMarketDataSource()
    private let compositionalLayout = CompositionalLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = openMarketDataSource
        collectionView.isPrefetchingEnabled = true
        collectionView.prefetchDataSource = openMarketDataSource
        collectionView.register(UINib(nibName: ProductCell.listNibName, bundle: nil), forCellWithReuseIdentifier: ProductCell.listIdentifier)
        collectionView.register(UINib(nibName: ProductCell.gridNibName, bundle: nil), forCellWithReuseIdentifier: ProductCell.gridItentifier)
        collectionView.collectionViewLayout = compositionalLayout.create(portraitHorizontalNumber: 1, landscapeHorizontalNumber: 1, verticalSize: 100, scrollDirection: .vertical)
        openMarketDataSource.requestProductList(collectionView: collectionView)
        openMarketDataSource.loadingIndicator = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func onCollectionViewTypeChanged(_ sender: UISegmentedControl) {
        openMarketDataSource.selectedView(sender, collectionView, compositionalLayout)
    }
}

extension OpenMarketViewController: LoadingIndicatable {
    func startAnimating() {
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
    }
    
    func stopAnimating() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
}

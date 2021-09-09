//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private let openMarketCollecionViewDataSource = OpenMarketCollectionViewDataSource()
    private let openMarketCollectionViewDelegate = OpenMarketCollectionViewDelegate()
    private let compositionalLayout = CompositionalLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        processCollectionView()
        registeredIdetifier()
        decidedLayout()
        openMarketCollecionViewDataSource.requestProductList(collectionView: collectionView)
        openMarketCollecionViewDataSource.loadingIndicator = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func processCollectionView() {
        collectionView.dataSource = openMarketCollecionViewDataSource
        collectionView.delegate = openMarketCollectionViewDelegate
        collectionView.prefetchDataSource = openMarketCollecionViewDataSource
        
    }
    
    private func registeredIdetifier() {
        collectionView.register(UINib(nibName: ProductCell.listNibName, bundle: nil), forCellWithReuseIdentifier: ProductCell.listIdentifier)
        collectionView.register(UINib(nibName: ProductCell.gridNibName, bundle: nil), forCellWithReuseIdentifier: ProductCell.gridItentifier)
    }
    
    private func decidedLayout() {
        collectionView.collectionViewLayout =
            compositionalLayout.create(portraitHorizontalNumber: 1,
                                       landscapeHorizontalNumber: 1,
                                       cellVerticalSize: .absolute(100),
                                       scrollDirection: .vertical,
                                       cellMargin: nil, viewMargin: nil)
    }
    
    @IBAction func onCollectionViewTypeChanged(_ sender: UISegmentedControl) {
        openMarketCollecionViewDataSource.selectedView(sender, collectionView, compositionalLayout)
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

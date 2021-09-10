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
        let listViewMargin =
            compositionalLayout.margin(top: 0, leading: 5, bottom: 0, trailing: 0)
        collectionView.collectionViewLayout =
            compositionalLayout.create(portraitHorizontalNumber: 1,
                                       landscapeHorizontalNumber: 1,
                                       cellVerticalSize: .absolute(100),
                                       scrollDirection: .vertical,
                                       cellMargin: nil, viewMargin: listViewMargin)
    }
    
    @IBAction func onCollectionViewTypeChanged(_ sender: UISegmentedControl) {
        openMarketCollecionViewDataSource.selectedView(sender, collectionView, compositionalLayout)
    }
}

extension OpenMarketViewController: LoadingIndicatable {
    func isHidden(_ isHidden: Bool) {
        loadingIndicator.isHidden = isHidden
    }
    
    func startAnimating() {
        loadingIndicator.startAnimating()
    }
    
    func stopAnimating() {
        loadingIndicator.stopAnimating()
    }
}

extension OpenMarketViewController {
    @IBAction func enrollModifyButton(_ sender: Any) {
        let alert = UIAlertController()
        let enroll = UIAlertAction(title: "등록", style: .default) { action in
            
        }
        let modify = UIAlertAction(title: "수정", style: .default) { action in
            
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(enroll)
        alert.addAction(modify)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

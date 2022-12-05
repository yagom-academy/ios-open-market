//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {
    //MARK: - Properties
    private let segmentedControl: LayoutSegmentedControl = LayoutSegmentedControl()
    private var collectionView: OpenMarketCollectionView!
    private var currentPage: Int = 1
    private let productPerPage: Int = 20
    private var hasNextPage: Bool = true
    private var indicatorView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewsIfNeeded()
        applySnapshotOfFetchedPage()
    }
    //MARK: - set Up View Method
    private func setUpViewsIfNeeded() {
        setSegmentedControl()
        setRightBarButton()
        setCollectionView()
        setIndicatorView()
        setUpRefreshControl()
    }
    
    func setUpRefreshControl() {
        let refreshControl: UIRefreshControl = UIRefreshControl()
     
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        collectionView.refreshControl = refreshControl
    }
    
    private func setSegmentedControl() {
        navigationItem.titleView = segmentedControl
        segmentedControl.addTarget(self,
                                   action: #selector(layoutSegmentedControlValueChanged),
                                   for: .valueChanged)
    }
    
    private func setRightBarButton() {
        let barButton: UIBarButtonItem = UIBarButtonItem(title: "+",
                                                         style: .plain,
                                                         target: self,
                                                         action: #selector(tappedAddProductButton))
        
        barButton.tintColor = .systemBlue
        navigationItem.setRightBarButton(barButton, animated: false)
    }
    
    private func setCollectionView() {
        collectionView = OpenMarketCollectionView(frame: view.bounds,
                                                  collectionViewLayout: CollectionViewLayout.defaultLayout)
        collectionView.backgroundColor = .white
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.openMarketDelegate = self
        view.addSubview(collectionView)
    }
    
    private func setIndicatorView() {
        let indicatorView: UIView = UIView(frame: view.bounds)
        indicatorView.backgroundColor = .systemGray6
        
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        indicator.center = indicatorView.center
        indicator.startAnimating()
        indicatorView.addSubview(indicator)
        
        view.addSubview(indicatorView)
        self.indicatorView = indicatorView
    }
    
    private func removeIndicatorView() {
        indicatorView?.removeFromSuperview()
        indicatorView = nil
    }
    //MARK: - objc Method
    @objc
    private func layoutSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        let list: Int = 0
        let grid: Int = 1
        
        switch sender.selectedSegmentIndex {
        case list:
            collectionView.updateLayout(of: .list)
        case grid:
            collectionView.updateLayout(of: .grid)
        default:
            return
        }
        collectionView.reloadData()
    }
    
    @objc
    private func tappedAddProductButton(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(ProductRegistrationViewController(), animated: false)
    }
    
    @objc
    private func refreshData(_ sender: UIRefreshControl) {
        self.currentPage = 1
        self.hasNextPage = true
        applySnapshotOfFetchedPage()
    }
    
    //MARK: - Snapshot Apply Method
    private func applySnapshotOfFetchedPage() {
        guard hasNextPage == true else { return }
        URLSession.shared.fetchPage(pageNumber: currentPage, productsPerPage: productPerPage) { (page) in
            guard let page: Page = page,
                  var currentSnapshot: NSDiffableDataSourceSnapshot = self.collectionView.currentSnapshot else {
                return
            }
            self.hasNextPage = page.hasNextPage
            if page.hasNextPage {
                self.currentPage += 1
            }
            let products: [Product] = Array(page.products.prefix(self.productPerPage))
            
            if currentSnapshot.numberOfSections != 0 {
                currentSnapshot.appendItems(products)
            } else {
                currentSnapshot.appendSections([.main])
                currentSnapshot.appendItems(products)
            }
            DispatchQueue.main.async {
                self.removeIndicatorView()
                self.collectionView.applySnapshot(currentSnapshot)
                self.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
}
//MARK: - Extension UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
extension ViewController: OpenMarketCollectionViewDelegate {
    func openMarketCollectionView(didRequestNextPage: Bool) -> Bool {
        applySnapshotOfFetchedPage()
        return hasNextPage
    }
}

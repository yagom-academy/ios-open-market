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
        navigationController?.pushViewController(UIViewController(), animated: false)
    }
    //MARK: - Snapshot Apply Method
    private func applySnapshotOfFetchedPage() {
        URLSession.shared.fetchPage(pageNumber: 1, productsPerPage: 1000) { (page) in
            guard let page: Page = page else { return }
            
            var snapshot: NSDiffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Product>()
            snapshot.appendSections([.main])
            snapshot.appendItems(page.products)
            
            DispatchQueue.main.async {
                self.removeIndicatorView()
                self.collectionView.applySnapshot(snapshot)
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

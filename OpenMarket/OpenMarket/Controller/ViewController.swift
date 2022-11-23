//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {
    private let segmentedControl: LayoutSegmentedControl = LayoutSegmentedControl()
    private var collectionView: OpenMarketCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsIfNeeded()
        fetchData()
    }
    
    private func setupViewsIfNeeded() {
        navigationItem.titleView = segmentedControl
        segmentedControl.addTarget(self,
                                   action: #selector(layoutSegmentedControlValueChanged),
                                   for: .valueChanged)
        collectionView = OpenMarketCollectionView(frame: view.bounds,
                                                  collectionViewLayout: CollectionViewLayout.defaultLayout)
        collectionView.backgroundColor = .white
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    @objc
    private func layoutSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            collectionView.updateLayout(of: .list)
        case 1:
            collectionView.updateLayout(of: .grid)
        default:
            return
        }
        collectionView.reloadData()
    }
}

extension ViewController {
    private func fetchData() {
        let dataAsset: NSDataAsset = NSDataAsset(name: "products")!
        let page: Page = try! JSONDecoder().decode(Page.self, from: dataAsset.data)
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(page.products)
        collectionView.applySnapshot(snapshot)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

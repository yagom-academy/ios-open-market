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
        applySnapshotOfFetchedPage()
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
    private func applySnapshotOfFetchedPage() {
        URLSession.shared.fetchPage(pageNumber: 1, productsPerPage: 1000) { (page) in
            guard let page = page else { return }
            var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
            snapshot.appendSections([.main])
            snapshot.appendItems(page.products)
            DispatchQueue.main.async {
                self.collectionView.applySnapshot(snapshot)
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

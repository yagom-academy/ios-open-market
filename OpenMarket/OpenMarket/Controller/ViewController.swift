//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {
    private let segmentedControl: LayoutSegmentedControl = LayoutSegmentedControl()
    private var collectionView: OpenMarketCollectionView!
    private var indicatorView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsIfNeeded()
        setIndicatorView()
        applySnapshotOfFetchedPage()
    }
    
    private func setupViewsIfNeeded() {
        navigationItem.titleView = segmentedControl
        segmentedControl.addTarget(self,
                                   action: #selector(layoutSegmentedControlValueChanged),
                                   for: .valueChanged)
        setRightBarButton()
        collectionView = OpenMarketCollectionView(frame: view.bounds,
                                                  collectionViewLayout: CollectionViewLayout.defaultLayout)
        collectionView.backgroundColor = .white
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func setRightBarButton() {
        let barButton: UIBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(tappedAddProductButton))
        barButton.tintColor = .systemBlue
        navigationItem.setRightBarButton(barButton, animated: false)
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
    
    @objc
    private func tappedAddProductButton(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(UIViewController(), animated: false)
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
                self.removeIndicatorView()
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

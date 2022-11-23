//
//  OpenMarket - ProductsViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ProductsViewController: UIViewController {
    let addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        
        return button
    }()
    
    lazy var segment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["LIST", "GRID"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(didChangedSegmentIndex(_:)), for: .valueChanged)

        return segment
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(ProductListCell.self, forCellWithReuseIdentifier: ProductListCell.identifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.titleView = segment
        
        self.view = collectionView
    }
    
    @objc func didChangedSegmentIndex(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
    }
}

extension ProductsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.bounds.size
        return CGSize(width: size.width - 10, height: size.height * 0.1)
    }
}

extension ProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCell.identifier, for: indexPath) as? ProductListCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .blue
        return cell
    }
}

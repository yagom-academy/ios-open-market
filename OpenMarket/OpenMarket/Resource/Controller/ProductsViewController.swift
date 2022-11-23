//
//  OpenMarket - ProductsViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ProductsViewController: UIViewController {
    enum Constant {
        static let edgeInsetValue: CGFloat = 8
    }
    var segmentIndex = 0
    
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
        
        collectionView.contentInset = UIEdgeInsets(
            top: Constant.edgeInsetValue,
            left: Constant.edgeInsetValue,
            bottom: 0,
            right: Constant.edgeInsetValue
        )

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
        
        segmentIndex = index
        collectionView.reloadData()
    }
}

extension ProductsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.size
        let index = (segmentIndex + 1)
        let contentsWidth = (size.width / CGFloat(index)) - (2 * Constant.edgeInsetValue)
        let contentsHeight = index == 1 ? size.height * 0.08 : size.height * 0.3
         
        return CGSize(width: contentsWidth, height: contentsHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.edgeInsetValue
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.edgeInsetValue
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
        
        cell.configureLayout()
        return cell
    }
}

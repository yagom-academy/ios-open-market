//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["list", "grid"])
        return segment
    }()
    
    var productCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = segmentControl
        configureProductCollectionView()
    }
    
    func configureProductCollectionView() {
        let configure = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configure)
        
        productCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        productCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(productCollectionView)
        NSLayoutConstraint.activate([
            productCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            productCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}


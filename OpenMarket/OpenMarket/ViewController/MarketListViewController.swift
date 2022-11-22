//
//  MarketListViewController.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/22.
//

import UIKit

class MarketListViewController: UIViewController {
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func createListLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: createListLayout())
        view.addSubview(collectionView)
    }
    
    
    
}

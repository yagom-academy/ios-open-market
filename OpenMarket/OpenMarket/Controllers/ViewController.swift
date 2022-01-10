//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    private var productCollectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    func configUI() {
        view.backgroundColor = .white
        configNavigationBar()
    }
    
    func configNavigationBar() {
        let segment = LayoutSegmentedControl(items: ["LIST", "GRID"])
        self.navigationController?.navigationBar.topItem?.titleView = segment
    }
    
    func createListLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
}

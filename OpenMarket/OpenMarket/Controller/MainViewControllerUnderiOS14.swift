//
//  MainViewControllerUnderiOS14.swift
//  OpenMarket
//
//  Created by papri, Tiana on 24/05/2022.
//

import UIKit

class MainViewControllerUnderiOS14: UIViewController {
    private var collectionView: UICollectionView?
    private var baseView = BaseView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItem()
    }
    
    private func setUpNavigationItem() {
        setUpSegmentation()
        navigationItem.titleView = baseView.segmentedControl
    }
    
    private func setUpSegmentation() {
        baseView.segmentedControl.setWidth(view.bounds.width * 0.18 , forSegmentAt: 0)
        baseView.segmentedControl.setWidth(view.bounds.width * 0.18, forSegmentAt: 1)
    }
}

//
//  OpenMarket - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
    lazy var baseView = BaseView(frame: view.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()
        view = baseView
        setUpNavigationItem()
    }
    
    func setUpNavigationItem() {
        setUpSegmentation()
        navigationItem.titleView = baseView.segmentedControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(registerProduct))
    }
    
    func setUpSegmentation() {
        baseView.segmentedControl.setWidth(view.bounds.width * 0.18 , forSegmentAt: 0)
        baseView.segmentedControl.setWidth(view.bounds.width * 0.18, forSegmentAt: 1)
        baseView.segmentedControl.addTarget(self, action: #selector(switchCollectionViewLayout), for: .valueChanged)
    }
    
    @objc func switchCollectionViewLayout() {
    }
    
    @objc func registerProduct() {
    }
}


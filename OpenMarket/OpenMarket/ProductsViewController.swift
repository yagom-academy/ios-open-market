//
//  OpenMarket - ProductsViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ProductsViewController: UIViewController {
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["LIST", "GRID"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemGray6
        
        return segmentedControl
    }()
    
    private let addProductButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "+"
        let attributes: [NSAttributedString.Key : Any] = [.font: UIFont.boldSystemFont(ofSize: 16)]
        barButton.setTitleTextAttributes(attributes, for: .normal)
        
        return barButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.titleView = self.segmentedControl
        self.navigationItem.rightBarButtonItem = self.addProductButton
    }
}


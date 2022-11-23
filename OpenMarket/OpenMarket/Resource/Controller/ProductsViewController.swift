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
        segment.addTarget(self, action: #selector(didChangedSegmentIndex(sender:)), for: .valueChanged)
        
        return segment
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.titleView = segment
    }
    
    @objc func didChangedSegmentIndex(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }
}


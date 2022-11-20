//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let segmentedControl: UISegmentedControl = {
        let item = ["LIST", "GRID"]
        let segmentedController = UISegmentedControl(items: item)
        segmentedController.translatesAutoresizingMaskIntoConstraints = false
        return segmentedController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
    }

    func configureNavigation() {
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add,
                                                            target: self, action: nil
        )
    }
}


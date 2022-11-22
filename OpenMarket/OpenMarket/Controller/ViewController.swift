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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = segmentControl
    }


}


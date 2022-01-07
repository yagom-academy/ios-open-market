//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
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
}

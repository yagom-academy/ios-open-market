//
//  OpenMarket - ViewController.swift
//  Created by Grumpy, OneTool
//  Copyright © yagom. All rights reserved.
// 

import UIKit

enum ArrangeMode: Int {
    case list = 0
    case grid = 1
}

class ViewController: UIViewController {
    var arrangeMode: ArrangeMode = .list
    let segmentedControl = UISegmentedControl(items: ["List", "Grid"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentLayout()
        segmentedControl.addTarget(self, action: #selector(arrangementChange(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        self.arrangementChange(segmentedControl)
    }
    
    
    func segmentLayout() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    }


}


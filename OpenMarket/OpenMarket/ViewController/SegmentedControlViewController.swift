//
//  SegmentedControlViewController.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/06/09.
//

import UIKit

class SegmentedControlViewController: UISegmentedControl {
    static let segmentedControl: UISegmentedControl = {
        let titles = ["LIST", "GRID"]
        var segmentedControl = UISegmentedControl(items: titles)
        segmentedControl.tintColor = UIColor.white
        segmentedControl.backgroundColor = UIColor.blue
        segmentedControl.selectedSegmentIndex = 0
        
        for index in 0...(titles.count - 1) {
            segmentedControl.setWidth(120, forSegmentAt: index)
        }
        
        segmentedControl.sizeToFit()
        segmentedControl.addTarget(self, action: #selector(Changed(by:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.sendActions(for: .valueChanged)
        return segmentedControl
    }()
    
    @objc func Changed(by segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: return
        case 1: return
        default: return
        }
    }

}

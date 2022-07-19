//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var segmentSwitch: UISegmentedControl!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    let jsonParser = JSONParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func switchView(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            firstView.alpha = 1
            secondView.alpha = 0
        case 1:
            firstView.alpha = 0
            secondView.alpha = 1
        default:
            break
        }
    }
}


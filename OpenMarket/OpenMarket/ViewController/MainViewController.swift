//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.isHidden = true
    }

    @IBAction func changeView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            listView.isHidden = false
            gridView.isHidden = true
        } else {
            listView.isHidden = true
            gridView.isHidden = false
        }
    }
}

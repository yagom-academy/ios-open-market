//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UIView!
    @IBOutlet weak var collectionView: UIView!
    
    @IBOutlet weak var collectionContainerView: UIView!
    @IBOutlet weak var tableContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alpha = 0.0
        // Do any additional setup after loading the view.
    }
    @IBAction func switchView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tableView.alpha = 1.0
            collectionView.alpha = 0.0
        } else {
            tableView.alpha = 0.0
            collectionView.alpha = 1.0
        }
    }
    
}


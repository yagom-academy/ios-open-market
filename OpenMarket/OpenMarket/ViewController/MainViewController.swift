//
//  MainViewController.swift
//  OpenMarket
//
//  Created by sole on 2021/02/04.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UIView!
    @IBOutlet weak var collectionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func switchView(_ sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0 {
            tableView.alpha = 1
            collectionView.alpha = 0
        } else {
            tableView.alpha = 0
            collectionView.alpha = 1
        }
    }
}

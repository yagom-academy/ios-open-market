//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI () {
        segment.addTarget(self, action: #selector(changedSegmentValue(_:)), for: .valueChanged)
    }
    
    @IBAction func touchUpAddButton(_ sender: UIButton) {
        print("➕")
    }
    
    @objc func changedSegmentValue(_ sender: UISegmentedControl) {
        
    }
}

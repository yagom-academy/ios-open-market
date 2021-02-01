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
        setUpCollection()
    }
    
    // MARK: - setUp UI
    private func setUpUI () {
        segment.addTarget(self, action: #selector(changedSegmentValue(_:)), for: .valueChanged)
    }
    
    private func setUpCollection() {
        // TODO: Lasagna - CollectionView List Type cell regist
        // TODO: Joons - CollectionVIew Grid Type cell Regist
    }
    
    @IBAction func touchUpAddButton(_ sender: UIButton) {
        // TODO: add logic in step3
        print("➕")
    }
    
    @objc func changedSegmentValue(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("click list")
        case 1:
            print("click grid")
        default:
            self.showErrorAlert(with: OpenMarketError.unknown, okHandler: nil)
        }
    }
}

//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {

    enum SegmentIndexs {
        static let list = 0
        static let grid = 1
    }
    
    @IBOutlet weak var listContainer: UIView!
    @IBOutlet weak var gridContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridContainer.isHidden = true
    }
    

    @IBAction func didTapSegment(segment : UISegmentedControl) {
        listContainer.isHidden = true
        gridContainer.isHidden = true
        
        if segment.selectedSegmentIndex == SegmentIndexs.list {
            listContainer.isHidden = false
            
            print("list on")
        
        } else if segment.selectedSegmentIndex == SegmentIndexs.grid {
            gridContainer.isHidden = false
            print("grid on")
        }
    }
 
    
}

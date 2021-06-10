//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
    
    let openMarketAPI: OpenMarketAPI = OpenMarketAPI(session: URLSession.shared)
    var items: [Item] = []
    
    @IBOutlet weak var listContainer: UIView!
    @IBOutlet weak var gridContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        downloadData()
        
        gridContainer.isHidden = true
    }

    func downloadData() {
        self.openMarketAPI.getItemList { result in
            self.items = result
            print("success download")
            
            NotificationCenter.default.post(name: NotificationNames.items.notificaion, object: result)
        }
    }
    
    @IBAction func didTapSegment(segment : UISegmentedControl) {
        listContainer.isHidden = true
        gridContainer.isHidden = true
        
        if segment.selectedSegmentIndex == 0 {
            listContainer.isHidden = false
            print("list on")
        
        } else if segment.selectedSegmentIndex == 1 {
            gridContainer.isHidden = false
            print("grid on")
            
        }
    }
}

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
            print("다운로드 완료!")
            
            NotificationCenter.default.post(name: NotificationNames.items.notificaion, object: result)
            
        }
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

//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let test1 = OpenMarketDataSource.init()
    
    @objc func notiTest(_ noti: Notification) {
        let test = noti.userInfo?["error"] as? Data
        print("\(String(describing: test))")
        print("------------")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = test1
        collectionView.prefetchDataSource = test1
        let layout = Layout.generate(self.view)
        collectionView.collectionViewLayout = layout
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.notiTest(_:)), name: NSNotification.Name.networkError, object: nil)
    }
}


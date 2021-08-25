//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
   private let openMarketDataSource = OpenMarketDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        setIndicatorStyle()
        activityIndicator.startAnimating()

        collectionView.dataSource = openMarketDataSource
        collectionView.prefetchDataSource = openMarketDataSource
        let layout = Layout.generate(self.view)
        collectionView.collectionViewLayout = layout
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.notifyNetworkError(_:)), name: NSNotification.Name.networkError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.nofityImageDownload), name: .imageDidDownload, object: nil)
    }
}

extension ViewController {
    func setIndicatorStyle() {
        activityIndicator.style = .large
        activityIndicator.color = .systemGray
        activityIndicator.hidesWhenStopped = true
    }
}

extension ViewController {
    @objc func notifyNetworkError(_ noti: Notification) {
        guard let error = noti.userInfo?["error"] as? NetworkError else { return }
        print(error.localizedDescription)
    }
    
    @objc func nofityImageDownload() {
        activityIndicator.stopAnimating()
        NotificationCenter.default.removeObserver(self, name: .imageDidDownload, object: nil)
    }
}

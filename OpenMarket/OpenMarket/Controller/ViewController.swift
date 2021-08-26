//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Property
    private let openMarketDataSource = OpenMarketDataSource()
    private lazy var layout = Layout.generate(self.view)
    private let delegate = OpenMarketCollectionViewDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Set Loading Indicater Style And Start
        setIndicatorStyle()
        activityIndicator.startAnimating()
        
        //MARK: Assign Datasource and Layout
        collectionView.dataSource = openMarketDataSource
        collectionView.delegate = delegate
        collectionView.collectionViewLayout = layout
        
        //MARK: Add NotificationObserver
        NotificationCenter.default.addObserver(self, selector: #selector(self.notifyNetworkError(_:)), name: NSNotification.Name.networkError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.nofityImageDownload), name: .imageDidDownload, object: nil)
    }
}

extension ViewController {
    //MARK: Indicator Style Method
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

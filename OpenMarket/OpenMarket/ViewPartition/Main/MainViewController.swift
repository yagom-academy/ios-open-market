//
//  OpenMarket - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var container: UICollectionView!
    
    private let networker = NetworkManager()
    private let dataSource = MainDataSource()
    private let delegate = MainDelegate()
    
    private var pageIndex: UInt = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container.dataSource = dataSource
        container.delegate = delegate
        
        loading.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestNewItemList()
    }
    
    private func requestNewItemList() {
        loading.startAnimating()
        do {
            try networker.getGoodsList(pageIndex: pageIndex) { [weak self] result in
                guard let its = self else { return }
                var itemList: GoodsList?
                
                switch result {
                case .success(let result):
                    itemList = result
                    its.pageIndex += 1
                case .failure(let error):
                    print(error)
                }
                
                DispatchQueue.main.async {
                    guard let itemList = itemList else { return }
                    its.dataSource.collectionView(its.container, reloadWith: itemList)
                    its.loading.stopAnimating()
                }
            }
        } catch {
            switch error {
            case HttpError.Case.requestBuildingFailed:
                print("?")
            default:
                print("default")
            }
        }
    }

}

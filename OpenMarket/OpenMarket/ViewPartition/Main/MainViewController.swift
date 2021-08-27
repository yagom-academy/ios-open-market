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
    private var delegate: MainDelegate?
    
    private var pageIndex: UInt = 1
    private var requestable = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = MainDelegate(self: self)
        
        container.dataSource = dataSource
        container.delegate = delegate
        
        loading.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestNewItemList()
    }
    
    func message(requestNewItemList condition: Bool) {
        if condition {
            requestNewItemList()
        }
    }
    
    private func requestNewItemList() {
        guard requestable == true else {
            let alert = UIAlertController(
                title: "😅",
                message: "더이상 요청이 불가능합니다",
                preferredStyle: .alert
            )
            
            let action = UIAlertAction(title: "닫기", style: .default)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        loading.startAnimating()
        do {
            try networker.getGoodsList(pageIndex: pageIndex) { [weak self] result in
                guard let its = self else { return }
                var itemList: GoodsList?
                
                switch result {
                case .success(let result):
                    itemList = result
                case .failure(let error):
                    print(error)
                }
                
                DispatchQueue.main.async {
                    guard let itemList = itemList else {
                        its.requestable = false
                        return
                    }
                    
                    if itemList.items.count == 0 {
                        its.requestable = false
                    } else {
                        its.pageIndex += 1
                        its.dataSource.collectionView(its.container, reloadWith: itemList)
                    }
                    
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

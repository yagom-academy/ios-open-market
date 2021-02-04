//
//  OpenMarket - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var itemTableView: UITableView!
    var itemList: ItemList?
    var currentPage: UInt = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpDelegateAndDataSource()
        loadItemList(page: currentPage)
    }
    
    func loadItemList(page: UInt) {
        ItemManager.shared.loadData(method: .get, path: .items, param: page) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                self.itemList = try? JSONDecoder().decode(ItemList.self, from: data)
                DispatchQueue.main.async {
                    if self.itemTableView.isHidden {
                        self.itemCollectionView.reloadData()
                    }
                    else if self.itemCollectionView.isHidden {
                        self.itemTableView.reloadData()
                    }
                }
            case .failure(let error):
                self.errorHandling(error: error)
            }
        }
    }
    
    private func setUpDelegateAndDataSource() {
        itemTableView.delegate = self
        itemTableView.dataSource = self
    }
    
    private func setUpNavigationBar() {
        let titles = ["List", "Grid"]
        let segmentControl: UISegmentedControl = UISegmentedControl(items: titles)
        segmentControl.selectedSegmentTintColor = UIColor.systemBlue
        segmentControl.backgroundColor = UIColor.white
        segmentControl.selectedSegmentIndex = 0
        for index in 0...titles.count - 1 {
            segmentControl.setWidth(80, forSegmentAt: index)
        }
        segmentControl.sizeToFit()
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: .normal)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentControl.sendActions(for: .valueChanged)
        
        navigationItem.titleView = segmentControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(moveToPostViewController))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.systemBlue
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            itemTableView.isHidden = false
            itemCollectionView.isHidden = true
            DispatchQueue.main.async {
                self.itemTableView.reloadData()
            }
        case 1:
            itemTableView.isHidden = true
            itemCollectionView.isHidden = false
            DispatchQueue.main.async {
                self.itemCollectionView.reloadData()
            }
        default:
            break
        }
    }
    
    @objc func moveToPostViewController() {
        
    }
}


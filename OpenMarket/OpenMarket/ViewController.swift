//
//  OpenMarket - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    var itemList: ItemList?
    var itemArray: [Item?] = []
    var isPaging: Bool = false
    var hasNextPage: Bool = false
    var currentPage: UInt = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLoadingIndicatorView()
        setUpSegmentedControl()
        setUpNavigationRightBarButton()
        setUpNotification()
        setUpDelegateAndDataSource()
        loadItemList(page: currentPage)
    }
    
    //MARK: SetUpLoadingIndicatorView
    private func setUpLoadingIndicatorView() {
        self.view.bringSubviewToFront(loadingIndicatorView)
        loadingIndicatorView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        loadingIndicatorView.startAnimating()
    }
    
    //MARK: SetUpNaviationBar
    private func setUpSegmentedControl() {
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
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            itemTableView.isHidden = false
            itemCollectionView.isHidden = true
            self.itemTableView.reloadData()
        case 1:
            itemTableView.isHidden = true
            itemCollectionView.isHidden = false
            self.itemCollectionView.reloadData()
        default:
            break
        }
    }
    
    private func setUpNavigationRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(moveToPostViewController))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.systemBlue
    }
    
    @objc func moveToPostViewController() {
        guard let postViewController = self.storyboard?.instantiateViewController(identifier: "PostViewController") else {
            return
        }
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
    
    //MARK: SetUpNotification
    private func setUpNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleLoadImageError), name: Notification.Name("failFetchImage"), object: nil)
    }
    
    @objc func handleLoadImageError(_ notification: Notification) {
        guard let error = notification.object as? OpenMarketError else {
            return
        }
        self.errorHandling(error: error)
    }
    
    //MARK: SetUpDelegateAndDataSource
    private func setUpDelegateAndDataSource() {
        itemTableView.delegate = self
        itemTableView.dataSource = self
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
    }
    
    //MARK: loadItemList
    func loadItemList(page: UInt) {
        ItemManager.shared.loadData(method: .get, path: .items, param: page) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                self.itemList = try? JSONDecoder().decode(ItemList.self, from: data)
                guard let items = self.itemList?.items, items.count > 0 else {
                    self.hasNextPage = false
                    DispatchQueue.main.async {
                        if self.itemCollectionView.isHidden {
                            self.itemTableView.reloadSections(IndexSet(integer: 1), with: .none)
                        }
                    }
                    return
                }
                self.hasNextPage = true
                self.itemArray.append(contentsOf: items)
                
                DispatchQueue.main.async {
                    self.loadingIndicatorView.stopAnimating()
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
}


//
//  OpenMarket - ListViewController.swift
//  Created by Zhilly, Dragon. 22/11/14
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    var product: ProductList?
    let networkManager: NetworkRequestable = NetworkManager(session: URLSession.shared)
    var cellIdentifier: String = "ListCollectionViewCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var viewModeController: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        loadData()
    }
    
    func loadData() {
        networkManager.request(from: URLManager.productList(pageNumber: 1, itemsPerPage: 200).url, httpMethod: HttpMethod.get, dataType: ProductList.self) { result in
            switch result {
            case .success(let data):
                self.product = data
                self.reloadData()
            case .failure(_):
                break
            }
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let collectionViewCellNib = UINib(nibName: cellIdentifier, bundle: nil)
        
        self.collectionView.register(collectionViewCellNib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    @IBAction func tapViewModeController(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            cellIdentifier = "ListCollectionViewCell"
            configureCollectionView()
            collectionView.reloadData()
        case 1:
            cellIdentifier = "GridCollectionViewCell"
            configureCollectionView()
            collectionView.reloadData()
        default:
            debugPrint("2")
        }
    }
    
}

extension ListViewController: UICollectionViewDelegate {
    
}

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let count: Int = product?.pages.count else {
            return 0
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch cellIdentifier {
        case "ListCollectionViewCell":
            return makeListCell(cellForItemAt: indexPath)
        case "GridCollectionViewCell":
            return makeGridCell(cellForItemAt: indexPath)
        default:
            return makeListCell(cellForItemAt: indexPath)
        }
    }
    
    func makeListCell(cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ListCollectionViewCell
        
        guard let productItem = product?.pages[indexPath.item] else {
            return cell
        }
        
        cell.configurationCell(item: productItem)
        
        return cell
    }
    func makeGridCell(cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GridCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GridCollectionViewCell
        
        guard let productItem = product?.pages[indexPath.item] else {
            return cell
        }
        
        return cell
    }
}


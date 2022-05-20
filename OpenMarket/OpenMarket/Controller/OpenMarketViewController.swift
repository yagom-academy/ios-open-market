//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    private let segmentControl = SegmentControl(items: ["list", "grid"])
    private var collectionView: UICollectionView?
    private var network: URLSessionProvider<ProductList>?
    private var productList: [Product]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        network = URLSessionProvider()
        fetchData(from: .productList(page: 1, itemsPerPage: 70))
        setup()
        addsegment()
    }
    
    private func fetchData(from: Endpoint) {
        network?.fetchData(from: from, completionHandler: { result in
            switch result {
            case .success(let data):
                self.productList = data.pages
            case .failure(_):
                print("")
            }
        })
    }
    
    private func setup() {
        let flowLayout = LayoutType.list.layout
        self.collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
        self.view.addSubview(collectionView ?? UICollectionView())
        self.collectionView?.dataSource = self
        self.collectionView?.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        self.collectionView?.register(GridCell.self, forCellWithReuseIdentifier: GridCell.identifier)
    }
    
    private func addsegment() {
        self.navigationItem.titleView = segmentControl
        segmentControl.addTarget(self, action: #selector(didChangeSegment), for: .valueChanged)
    }
    
    @objc func didChangeSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            collectionView?.collectionViewLayout = LayoutType.list.layout
        case 1:
            collectionView?.collectionViewLayout = LayoutType.grid.layout
        default:
            return
        }
        collectionView?.reloadData()
    }
}

extension OpenMarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let product = productList?[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        guard let thumbnail = product.thumbnail else {
            return UICollectionViewCell()
        }
        
        guard let url = URL(string: thumbnail) else {
            return UICollectionViewCell()
        }
        
        if segmentControl.selectedSegmentIndex == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath) as? ListCell else {
                return UICollectionViewCell()
            }
                
                network?.fetchImage(from: url, completionHandler: { result in
                    switch result {
                    case .success(let data):
                        cell.update(image: data)
                    case .failure(_):
                        break
                    }
                })
                
                cell.update(data: product)
                return cell
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCell.identifier, for: indexPath) as? GridCell else {
                return UICollectionViewCell()
            }
                
                network?.fetchImage(from: url, completionHandler: { result in
                    switch result {
                    case .success(let data):
                        cell.update(image: data)
                    case .failure(_):
                        break
                    }
                })
                
                cell.update(data: product)
                return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList?.count ?? .zero
    }
}

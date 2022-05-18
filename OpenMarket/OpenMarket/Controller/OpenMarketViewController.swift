//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    private let segmentControl = UISegmentedControl(items: ["list", "grid"])
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
        fetchData(from: .productList(page: 1, itemsPerPage: 20))
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
        let flowLayout = listCellLayout()
        self.collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
        self.view.addSubview(collectionView ?? UICollectionView())
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        self.collectionView?.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
    }
    
    private func listCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 7
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height / 14 )
        return layout
    }
    
    private func addsegment() {
        segmentControl.selectedSegmentTintColor = .systemBlue
        segmentControl.layer.addBorder(edges: [.all], color: .systemBlue, thickness: 2)
        segmentControl.selectedSegmentIndex = 0
        let attribute = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        segmentControl.setTitleTextAttributes(attribute, for: .normal)
        let attribute2 = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentControl.setTitleTextAttributes(attribute2, for: UIControl.State.selected)
        self.navigationItem.titleView = segmentControl
    }
}

extension OpenMarketViewController: UICollectionViewDelegate {
    
}

extension OpenMarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath) as? ListCell else {
            return UICollectionViewCell()
        }
        
        guard let product = productList?[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        guard let url = product.thumbnail else {
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList?.count ?? .zero
    }
}

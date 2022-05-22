//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class OpenMarketViewController: UIViewController {
    private let segmentControl = SegmentControl(items: LayoutType.inventory)
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
        fetchData(from: .productList(page: 1, itemsPerPage: 110))
        setupCollectionView()
        setupSegmentControl()
    }
    
    private func fetchData(from: Endpoint) {
        network?.fetchData(from: from, completionHandler: { result in
            switch result {
            case .success(let data):
                self.productList = data.pages
            case .failure(_):
                return
            }
        })
    }
    
    private func setupCollectionView() {
        self.collectionView = UICollectionView(frame: view.frame, collectionViewLayout: drawListCell())
        self.view.addSubview(collectionView ?? UICollectionView())
        self.collectionView?.dataSource = self
        self.collectionView?.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        self.collectionView?.register(GridCell.self, forCellWithReuseIdentifier: GridCell.identifier)
    }
    
    private func setupSegmentControl() {
        self.navigationItem.titleView = segmentControl
        segmentControl.addTarget(self, action: #selector(didChangeSegment), for: .valueChanged)
    }
    
    @objc private func didChangeSegment(_ sender: UISegmentedControl) {
        
        guard let layoutType = LayoutType(rawValue: sender.selectedSegmentIndex) else {
            return
        }
        
        switch layoutType {
        case .list:
            collectionView?.collectionViewLayout = drawListCell()
        case .grid:
            collectionView?.collectionViewLayout = drawGridCell()
        }
        collectionView?.reloadData()
    }
    
    private func drawListCell() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height / 14)
        return layout
    }
    
    private func drawGridCell() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: view.frame.width / 2.2, height: view.frame.height / 3)
        return layout
    }
}

extension OpenMarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let product = productList?[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        guard let layoutType = LayoutType(rawValue: segmentControl.selectedSegmentIndex) else {
            return UICollectionViewCell()
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: layoutType.cell.identifier, for: indexPath) as? CustomCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(data: product)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList?.count ?? .zero
    }
}

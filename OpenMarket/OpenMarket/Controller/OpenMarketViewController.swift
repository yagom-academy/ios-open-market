//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    private let segmentControl = UISegmentedControl(items: ["list", "grid"])
    private var collectionView: UICollectionView?
    private var productList: [Product] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    private var network: URLSessionProvider<ProductList>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        network = URLSessionProvider()
        getData(from: .productList(page: 1, itemsPerPage: 12))
        setup()
        addsegment()
    }
    
    func getData(from: Endpoint) {
        network?.fetchData(from: from, completionHandler: { result in
            switch result {
            case .success(let data):
                self.productList = data.pages!
            case .failure(_):
                print("")
            }
        })
    }
    
    func setup() {
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
        layout.minimumLineSpacing = 2
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height / 14 )
        return layout
    }
    
    func addsegment() {
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
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
}

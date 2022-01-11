//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
    private var productList: [Product] = []
    private var currentCellIdentifier = ProductCell.listIdentifier
    
    @IBOutlet private weak var collectionView: ProductsCollectionView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView! {
        didSet {
            indicator.startAnimating()
            indicator.isHidden = false
        }
    }
    @IBOutlet private weak var segmentControl: UISegmentedControl! {
        didSet {
            let normal: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
            let selected: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black]
            segmentControl.setTitleTextAttributes(normal, for: .normal)
            segmentControl.setTitleTextAttributes(selected, for: .selected)
            segmentControl.selectedSegmentTintColor = .white
            segmentControl.backgroundColor = .black
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        requestProducts()
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            self.collectionView.isHidden = false
        }
    }
    
    func requestProducts() {
        let networkManager: NetworkManager = NetworkManager()
        guard let request = networkManager.requestListSearch(page: 1, itemsPerPage: 10) else {
            return
        }
        
        networkManager.fetch(request: request, decodingType: Products.self) { result in
            switch result {
            case .success(let products):
                self.productList = products.pages
                self.reload()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func switchSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentCellIdentifier = ProductCell.listIdentifier
            collectionView.setUpListFlowLayout()
            collectionView.scrollToTop()
            collectionView.reloadData()
        case 1:
            currentCellIdentifier = ProductCell.gridItentifier
            collectionView.setUpGridFlowLayout()
            collectionView.scrollToTop()
            collectionView.reloadData()
        default:
            showAlert(message: "알 수 없는 에러가 발생했습니다.")
            return
        }
    }
    
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
      cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: currentCellIdentifier,
            for: indexPath) as? ProductCell else {
            fatalError()
        }
        cell.styleConfigure(identifier: currentCellIdentifier)
        cell.productConfigure(product: productList[indexPath.row])
        
        return cell
    }
}
